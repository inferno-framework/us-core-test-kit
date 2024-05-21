require_relative 'resource_checker'
require_relative 'granular_scope'

module USCoreTestKit
  module GranularScopeSearchTest
    include ResourceChecker
    include GranularScope

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

    def load_previous_requests
      search_params_as_hash = search_param_names.each_with_object({}) do |name, hash|
        hash[name] = nil
      end
      @previous_requests ||=
        load_tagged_requests(search_params_tag(search_params_as_hash))
          .sort_by { |request| request.index }
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
