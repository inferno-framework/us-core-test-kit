# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class CarePlanClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_care_plan_client_read_test

        title 'SHALL support read of CarePlan'

        description %(
          The client demonstrates SHALL support for reading CarePlan.
        )

        def failure_message
          "Did not receive a request for `CarePlan` with id: `us-core-client-tests-care-plan`."
        end

        run do
          requests = load_tagged_requests(READ_CARE_PLAN_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'CarePlan')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-care-plan')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
