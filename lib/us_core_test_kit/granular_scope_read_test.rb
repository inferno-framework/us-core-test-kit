require_relative 'resource_search_param_checker'
require_relative 'granular_scope'

module USCoreTestKit
  module GranularScopeReadTest
    extend Forwardable
    include ResourceSearchParamChecker
    include GranularScope

    def_delegators 'self.class', :metadata
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
          resource_matches_param?(prev_resource, scope[:name], current_scope.split('=').last)
        end
        skip_if resource_matching_scope.nil?, "Unable to find any resources to match scope #{current_scope}"

        fhir_read resource_type, resource_matching_scope.id

        assert_response_status(200)
        assert_resource_type(resource_type)
      end

      nonmatching_resource = previous_resources_for_reads.find do |prev_resource|
        resource_specific_granular_scope_search_params.none? do |scope|
          resource_matches_param?(prev_resource, scope[:name], scope[:value])
        end
      end
      if nonmatching_resource
        fhir_read resource_type, nonmatching_resource.id
        assert (response && response[:status]) != 200, "Server incorrectly responded with a successful status, read should fail due to scopes."

        begin
          res = resource
        rescue NoMethodError
          res = nil
        end

        assert (!res || res.resourceType == 'OperationOutcome'), "Read should fail due to scopes. Server shall return 4xx status code with an optional OperationOutcome payload."
      else
        info "Unable to find a resource that does not match scopes."
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

    def unescape_search_value(value)
      value&.gsub('\\,', ',')
    end

    def search_params_tag(params)
      "#{resource_type}?#{params.keys.join('&')}"
    end
  end
end
