# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class CarePlanClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_care_plan_client_read_test
        title 'SHALL support read of CarePlan'
        description %(
          The client demonstrates SHALL support for reading CarePlan.
        )

        def skip_message
          "Inferno did not receive any read requests for the `CarePlan` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core CarePlan Profile: `CarePlan/us-core-client-tests-care-plan`."
        end

        run do
          requests = load_tagged_requests(READ_CARE_PLAN_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-care-plan')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
