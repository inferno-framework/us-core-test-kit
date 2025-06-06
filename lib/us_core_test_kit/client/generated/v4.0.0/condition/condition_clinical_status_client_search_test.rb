# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ConditionClinicalStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_condition_clinical_status_client_search_test
        title 'SHOULD support clinical-status search of Condition'
        description %(
          The client demonstrates SHOULD support for searching clinical-status on Condition.
        )
        optional true

        input :condition_support,
              optional: true

        def required_params
          ["clinical-status"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Condition` resource type, so support for US Core Condition Profile is not expected."
        end

        def failure_message
          "No searches made for the `Condition` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if condition_support.blank?, skip_message
          else
            skip_if condition_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_CONDITION_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
