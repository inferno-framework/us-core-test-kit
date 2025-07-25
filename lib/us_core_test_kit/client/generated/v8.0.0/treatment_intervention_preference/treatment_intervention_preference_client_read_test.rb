# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class TreatmentInterventionPreferenceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_treatment_intervention_preference_client_read_test
        title 'SHALL support read of TreatmentInterventionPreference'
        description %(
          The client demonstrates SHALL support for reading TreatmentInterventionPreference.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Treatment Intervention Preference Profile: `Observation/us-core-client-tests-treatment-intervention-preference`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-treatment-intervention-preference')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
