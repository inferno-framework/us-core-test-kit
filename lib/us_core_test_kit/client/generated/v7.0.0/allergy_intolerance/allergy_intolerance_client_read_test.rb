# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class AllergyIntoleranceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_allergy_intolerance_client_read_test
        title 'SHALL support read of AllergyIntolerance'
        description %(
          The client demonstrates SHALL support for reading AllergyIntolerance.
        )

        def skip_message
          "Inferno did not receive any read requests for the `AllergyIntolerance` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core AllergyIntolerance Profile: `AllergyIntolerance/us-core-client-tests-allergy-intolerance`."
        end

        run do
          requests = load_tagged_requests(READ_ALLERGY_INTOLERANCE_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-allergy-intolerance')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
