# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class MedicationDispenseClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_medication_dispense_client_read_test

        title 'SHALL support read of MedicationDispense'

        description %(
          The client demonstrates SHALL support for reading MedicationDispense.
        )

        def failure_message
          "Did not receive a request for `MedicationDispense` with id: `us-core-client-tests-medication-dispense`."
        end

        run do
          requests = load_tagged_requests(READ_MEDICATION_DISPENSE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'MedicationDispense')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-medication-dispense')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
