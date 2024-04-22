module USCoreTestKit
  module GranularScopeReadTest
    def self.included(klass)
      klass.input(:received_scopes)
      klass.attr_accessor :previous_requests
    end

    def run_scope_read_test
      assert granular_scopes.present?, "No granular scopes were received for #{resource_type} resources"
      resource_scopes = granular_scopes.select {|scope| scope.include?(resource_type)}

      load_previous_requests
      skip_if previous_requests.blank?,
              "No #{resource_type} reads found"
      previous_resources_for_reads = previous_request_resources.values.flatten

      resource_specific_granular_scope_search_params.each do |scope| 
        current_scope = granular_scopes.find {|granular| granular.include?(scope[:name]) && granular.include?(scope[:value])}

        resource_matching_scope = previous_resources_for_reads.find do |prev_resource| 
          resource_matches_param?(prev_resource, scope[:name], scope[:value])
        end
        skip_if resource_matching_scope.nil?, "Unable to find any resources to match scope #{current_scope}"

        fhir_read resource_type, resource_matching_scope.id

        assert_response_status(200)
        assert_resource_type(resource_type)
        assert resource.id.present? && resource.id == resource_matching_scope.id, "Unable to read resource #{resource_matching_scope.id}, but it matches scopes"
      end

      nonmatching_resource = previous_resources_for_reads.find do |prev_resource|
        resource_specific_granular_scope_search_params.all? do |scope| 
          !resource_matches_param?(prev_resource, scope[:name], scope[:value])
        end
      end
      if nonmatching_resource
        fhir_read resource_type, nonmatching_resource.id
        #TODO: Decide assertions for nonmatching resources
        assert !resource.id.present?, "Resource #{nonmatching_resource.id} does not match the scopes, but was still read."
      else
        info "Unable to find a resource that does not fit scopes."
      end
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

    def unescape_search_value(value)
      value&.gsub('\\,', ',')
    end
    
    def resource_matches_param?(resource, search_param_name, escaped_search_value, values_found = [])
      search_value = unescape_search_value(escaped_search_value)
      paths = search_param_paths(search_param_name)

      match_found = false

      paths.each do |path|
        type = metadata.search_definitions[search_param_name.to_sym][:type]
        values_found =
          resolve_path(resource, path)
            .map do |value|
          if value.is_a? FHIR::Reference
            value.reference
          else
            value
          end
        end

        match_found =
          case type
          when 'Period', 'date', 'instant', 'dateTime'
            values_found.any? { |date| validate_date_search(search_value, date) }
          when 'HumanName'
            # When a string search parameter refers to the types HumanName and Address,
            # the search covers the elements of type string, and does not cover elements such as use and period
            # https://www.hl7.org/fhir/search.html#string
            search_value_downcase = search_value.downcase
            values_found.any? do |name|
              name&.text&.downcase&.start_with?(search_value_downcase) ||
                name&.family&.downcase&.start_with?(search_value_downcase) ||
                name&.given&.any? { |given| given.downcase.start_with?(search_value_downcase) } ||
                name&.prefix&.any? { |prefix| prefix.downcase.start_with?(search_value_downcase) } ||
                name&.suffix&.any? { |suffix| suffix.downcase.start_with?(search_value_downcase) }
            end
          when 'Address'
            search_value_downcase = search_value.downcase
            values_found.any? do |address|
              address&.text&.downcase&.start_with?(search_value_downcase) ||
                address&.city&.downcase&.start_with?(search_value_downcase) ||
                address&.state&.downcase&.start_with?(search_value_downcase) ||
                address&.postalCode&.downcase&.start_with?(search_value_downcase) ||
                address&.country&.downcase&.start_with?(search_value_downcase)
            end
          when 'CodeableConcept'
            # FHIR token search (https://www.hl7.org/fhir/search.html#token): "When in doubt, servers SHOULD
            # treat tokens in a case-insensitive manner, on the grounds that including undesired data has
            # less safety implications than excluding desired behavior".
            codings = values_found.flat_map(&:coding)
            if search_value.include? '|'
              system = search_value.split('|').first
              code = search_value.split('|').last
              codings&.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
            else
              codings&.any? { |coding| coding.code&.casecmp?(search_value) }
            end
          when 'Coding'
            if search_value.include? '|'
              system = search_value.split('|').first
              code = search_value.split('|').last
              values_found.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
            else
              values_found.any? { |coding| coding.code&.casecmp?(search_value) }
            end
          when 'Identifier'
            if search_value.include? '|'
              values_found.any? { |identifier| "#{identifier.system}|#{identifier.value}" == search_value }
            else
              values_found.any? { |identifier| identifier.value == search_value }
            end
          when 'string'
            searched_values = search_value.downcase.split(/(?<!\\\\),/).map{ |string| string.gsub('\\,', ',') }
            values_found.any? do |value_found|
              searched_values.any? { |searched_value| value_found.downcase.starts_with? searched_value }
            end
          else
            # searching by patient requires special case because we are searching by a resource identifier
            # references can also be URLs, so we may need to resolve those URLs
            if ['subject', 'patient'].include? search_param_name.to_s
              id = search_value.split('Patient/').last
              possible_values = [id, "Patient/#{id}", "#{url}/Patient/#{id}"]
              values_found.any? do |reference|
                possible_values.include? reference
              end
            else
              search_values = search_value.split(/(?<!\\\\),/).map { |string| string.gsub('\\,', ',') }
              values_found.any? { |value_found| search_values.include? value_found }
            end
          end

        break if match_found
      end

      match_found
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
  end
end
