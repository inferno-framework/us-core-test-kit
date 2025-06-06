# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class CarePlanClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_care_plan_client_read_test
        title 'SHALL support read of CarePlan'
        description %(
          The client demonstrates SHALL support for reading CarePlan.
        )

        input :care_plan_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `CarePlan` resource type, so support for US Core CarePlan Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core CarePlan Profile: `CarePlan/us-core-client-tests-care-plan`."
        end

        run do
          if parent_optional?
            omit_if care_plan_support.blank?, skip_message
          else
            skip_if care_plan_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_CARE_PLAN_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-care-plan')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
