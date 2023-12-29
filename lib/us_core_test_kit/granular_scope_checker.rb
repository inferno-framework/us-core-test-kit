module USCoreTestKit
  module GranularScopeChecker
    def self.included(klass)
      klass.input(:received_scopes)
    end

    def granular_scopes
      @granular_scopes ||=
        received_scopes
          .split(' ')
          .select { |scope| scope.start_with?(resource_type) && scope.include?('?') }
    end

    def granular_scope_search_params
      @granular_scope_search_params ||=
        granular_scopes.each_with_object do |scope, search_params|
          _, granular_scope = scope.split('?')
          search_name, search_value = granular_scope.split('=')
          search_params[search_name] = search_value
        end
    end

    def check_granular_scopes(params, resources)
      assert granular_scopes.present?, "No granular scopes were received for #{resource_type} resources"

      resource_ids_which_do_not_match_scopes = mismatched_resources(resources).map(&:id)

      assert resource_ids_which_do_not_match_scopes.blank?,
             'Resources with the following ids were received, but do not match the granted granular scopes: ' \
             "#{resource_ids_which_do_not_match_scopes.join(', ')}"

      resource_ids_found = resources.map(&:id)

      expected_ids = expected_resource_ids(params)
      missing_resource_ids = expected_ids - resource_ids_found

      assert missing_resource_ids.blank?,
             "Expected to receive resources with the following ids: #{missing_resource_ids.join(', ')}"

      extra_resource_ids = resource_ids_found - expected_ids

      assert extra_resource_ids.blank?,
             'Received resources with the following ids which were not received using resource-level scopes' \
             "#{extra_resource_ids.join(', ')}"
    end

    def previous_resources(params)
      load_tagged_requests(search_params_tag(params))
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

    def expected_resource_ids(params)
      previous_resources(params)
        .select do |resource|
          granular_scope_search_params.any? do |param_name, param_value|
            resource_matches_param?(resource, param_name, param_value)
          end
        end
        .map(&:id)
    end

    def mismatched_resources(resources)
      resources.reject do |resource|
        granular_scope_search_params.any? do |param_name, param_value|
            resource_matches_param?(resource, param_name, param_value)
          end
      end
    end
  end
end
