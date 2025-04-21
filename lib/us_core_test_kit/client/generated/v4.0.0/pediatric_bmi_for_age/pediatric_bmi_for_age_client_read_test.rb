# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class PediatricBmiForAgeClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_pediatric_bmi_for_age_client_read_test

        title 'SHALL support read of PediatricBmiForAge'

        description %(
          The client demonstrates SHALL support for reading PediatricBmiForAge.
        )

        def failure_message
          "Did not receive a request for `Observation` with id: `us-core-client-tests-pediatric-bmi-for-age`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Observation')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-pediatric-bmi-for-age')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
