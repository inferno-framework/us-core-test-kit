# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class AllergyIntoleranceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_allergy_intolerance_client_read_test

        title 'SHALL support read of AllergyIntolerance'

        description %(
          The client demonstrates SHALL support for reading AllergyIntolerance.
        )

        def failure_message
          "Did not receive a request for `AllergyIntolerance` with id: `us-core-client-tests-allergy-intolerance`."
        end

        run do
          requests = load_tagged_requests(READ_ALLERGY_INTOLERANCE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'AllergyIntolerance')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-allergy-intolerance')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
