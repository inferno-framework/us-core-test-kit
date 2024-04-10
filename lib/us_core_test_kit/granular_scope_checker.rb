module USCoreTestKit
  module GranularScopeChecker
    def self.included(klass)
      klass.input(:received_scopes)
      klass.attr_accessor :previous_requests
    end

    def run_scope_check_test
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
      load_previous_read_requests
      skip_if previous_requests.blank?,
              "No #{resource_type} reads found"

      previous_requests.each do |previous_request|
        resource_id = id_from_read(previous_request)
        #search_method = previous_request.verb.to_sym
        #params = search_method == :get ? previous_request.query_parameters : Hash[URI.decode_www_form(previous_request.request_body)]
        fhir_read resource_type, resource_id

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
        previous_ids = previous_request.id
        missing_ids = previous_ids == found_ids.first

        assert !missing_ids,
               'Resources with the following ids were received when using resource-level scopes, ' \
               "but not when using granular scopes: #{previous_request.id}"

        unexpected_ids = found_ids - previous_ids

        assert unexpected_ids.empty?,
               'Resources with the following ids were received when using granular scopes, ' \
               "but not when using resource-level scopes: #{unexpected_ids.join(', ')}"
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
      info "Checking scopes"
      info "#{received_scopes}"
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

    def load_previous_requests
      search_params_as_hash = search_param_names.each_with_object({}) do |name, hash|
        hash[name] = nil
      end
      @previous_requests ||=
        load_tagged_requests(search_params_tag(search_params_as_hash))
          .sort_by { |request| request.index }
    end
    
    def load_previous_read_requests
      @previous_requests ||= load_tagged_requests("#{resource_type}_Read").sort_by { |request| request.index }
    end

    def id_from_read(previous_read_request)
      JSON.parse(previous_read_request.response_body)["entry"][0]["resource"]["id"]
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
