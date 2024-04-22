module USCoreTestKit
  module GranularScopeSearchTest
    def self.included(klass)
      klass.input(:received_scopes)
      klass.attr_accessor :previous_requests
    end

    def run_scope_search_test
      assert granular_scopes.present?, "No granular scopes were received for #{resource_type} resources"

      load_previous_requests

      skip_if previous_requests.blank?,
              "No #{resource_type} searches with search params #{search_param_names.join(' & ')} found"

      previous_request_resources.each do |previous_request, all_previous_resources|
        search_method = previous_request.verb.to_sym
        params = search_method == :get ? previous_request.query_parameters : Hash[URI.decode_www_form(previous_request.request_body)]
        fhir_search(resource_type, params:, search_method:)

        found_resources =
          if request.status != 200
            []
          else
            fetch_all_bundled_resources
          end

        mismatched_ids = mismatched_resource_ids(found_resources)

        assert mismatched_ids.empty?,
               'Resources with the following ids were received even though they do not match the ' \
               "granted granular scopes: #{mismatched_ids.join(', ')}"

        found_ids = found_resources.map(&:id)
        previous_ids = expected_resource_ids(all_previous_resources)
        missing_ids = previous_ids - found_ids

        assert missing_ids.empty?,
               'Resources with the following ids were received when using resource-level scopes, ' \
               "but not when using granular scopes: #{missing_ids.join(', ')}"

        unexpected_ids = found_ids - previous_ids

        assert unexpected_ids.empty?,
               'Resources with the following ids were received when using granular scopes, ' \
               "but not when using resource-level scopes: #{unexpected_ids.join(', ')}"
      end
    end

    def run_scope_check_read_test
      assert granular_scopes.present?, "No granular scopes were received for #{resource_type} resources"
      resource_scopes = granular_scopes.select {|scope| scope.include?(resource_type)}

      load_previous_requests_for_reads
      skip_if previous_requests.blank?,
              "No #{resource_type} reads found"
      previous_resources_for_reads = previous_request_resources.values.flatten

      resource_specific_granular_scope_search_params.each do |scope| 
        resource_matching_scope = previous_resources_for_reads.find {|prev_resource| search_param_value(scope[:name], prev_resource) == scope[:value]}
        skip_if resource_matching_scope.nil?, "Unable to find any resources to match scope #{granular_scopes.find {|granular| granular.include?(scope[:name]) && granular.include?(scope[:value])}}"

        fhir_read resource_type, resource_matching_scope.id

        assert_response_status(200)
        assert_resource_type(resource_type)
        assert resource.id.present? && resource.id == resource_matching_scope.id, "Unable to read resource #{resource_matching_scope.id}, but it matches scopes"
      end

      nonmatching_resource = previous_resources_for_reads.find do |prev_resource|
        resource_specific_granular_scope_search_params.all? { |scope| search_param_value(scope[:name], prev_resource) != scope[:value]}
      end

      skip_if nonmatching_resource.nil?, "Unable to find a resource that does not match scopes"
      fhir_read resource_type, nonmatching_resource.id

      assert_response_status(401)
      assert_resource_type(:OperationOutcome)
      assert !resource.id.present?, "Resource #{nonmatching_resource.id} does not match the scopes, but was still read."
    end

    def previous_request_resources
      first_request = previous_requests.first
      next_page_url = nil
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_requests.each_with_object(hash) do |request, request_resource_hash|
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource).select { |resource| resource.resourceType == resource_type }
          else
            []
          end

        first_request = request if request.url != next_page_url

        request_resource_hash[first_request].concat(request_resources)

        next if request.resource&.resourceType != 'Bundle'

        next_page_url = request.resource&.link&.find { |link| link.relation == 'next' }&.url
      end
    end

    def granular_scopes
      @granular_scopes ||=
        received_scopes
          .split(' ')
          .select do |scope|
            (scope.start_with?("patient/#{resource_type}") || scope.start_with?("user/#{resource_type}")) &&
              scope.include?('?')
          end
    end

    def granular_scope_search_params
      @granular_scope_search_params ||=
        granular_scopes.map do |scope|
          _, granular_scope = scope.split('?')
          name, value = granular_scope.split('=')

          {
            name:,
            value:
          }
        end
    end

    def resource_specific_granular_scope_search_params
      @resource_specific_granular_scope_search_params ||=
        granular_scopes.select {|scope| scope.include?(resource_type)}.map do |scope|
          _, granular_scope = scope.split('?')
          name, value = granular_scope.split('=')
          _, value = value.split('|')
          {
            name:,
            value:
          }
      end
    end

    def load_previous_requests
      search_params_as_hash = search_param_names.each_with_object({}) do |name, hash|
        hash[name] = nil
      end
      @previous_requests ||=
        load_tagged_requests(search_params_tag(search_params_as_hash))
          .sort_by { |request| request.index }
    end
    
    def load_previous_requests_for_reads
      params = metadata.searches.first[:names]
      search_params_as_hash = params.each_with_object({}) do |name, hash|
        hash[name] = nil
      end
      @previous_requests ||=
        load_tagged_requests(search_params_tag(search_params_as_hash))
          .sort_by { |request| request.index }
    end

    def search_param_paths(name, resource = resource_type)
      paths = metadata.search_definitions[name.to_sym][:paths]
      if paths.first =='class'
        paths[0] = 'local_class'
      end

      paths.map { |path| path.delete_prefix("Resource.") }  
    end

    def search_param_value(name, resource)
      paths = search_param_paths(name, resource.resourceType)
      search_value = nil
      paths.each do |path|
        element = find_a_value_at(resource, path) { |element| element_has_valid_value?(element) }
        search_value =
          case element
          when FHIR::Period
            if element.start.present?
              'gt' + (DateTime.xmlschema(element.start) - 1).xmlschema
            else
              end_datetime = get_fhir_datetime_range(element.end)[:end]
              'lt' + (end_datetime + 1).xmlschema
            end
          when FHIR::Reference
            element.reference
          when FHIR::CodeableConcept
            find_a_value_at(element, 'coding.code')
          when FHIR::Identifier
            element.value
          when FHIR::Coding
            element.code
          when FHIR::HumanName
            element.family || element.given&.first || element.text
          when FHIR::Address
            element.text || element.city || element.state || element.postalCode || element.country
          when FHIR::Extension
            element.valueReference.reference
          else
            element
          end

        break if search_value.present?
      end

      escaped_value = search_value&.gsub(',', '\,')
      escaped_value
    end

    def element_has_valid_value?(element)
      case element
      when FHIR::Reference
        element.reference.present?
      when FHIR::CodeableConcept
        find_a_value_at(element, 'coding.code').present?
      when FHIR::Identifier
        element.value.present?
      when FHIR::Coding
        element.code.present?
      when FHIR::HumanName
        (element.family || element.given&.first || element.text).present?
      when FHIR::Address
        (element.text || element.city || element.state || element.postalCode || element.country).present?
      else
        true
      end
    end

    def previous_resources(params)
      previous_requests(params)
        .flat_map do |request|
          resource = request.resource
          if resource.is_a?(FHIR::Bundle)
            resource.entry&.map(&:resource)
          else
            resource
          end
        end
        .compact
        .select { |resource| resource.resourceType == resource_type }
    end

    def expected_resource_ids(resources)
      resources
        .select do |resource|
          granular_scope_search_params.any? do |param|
            resource_matches_param?(resource, param[:name], param[:value])
          end
        end
        .map(&:id)
    end

    def mismatched_resource_ids(resources)
      resources
        .reject do |resource|
          granular_scope_search_params.any? do |param|
            resource_matches_param?(resource, param[:name], param[:value])
          end
        end
        .map(&:id)
    end
  end
end
