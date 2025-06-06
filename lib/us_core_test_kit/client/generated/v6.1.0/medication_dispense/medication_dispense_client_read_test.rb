# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class MedicationDispenseClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_medication_dispense_client_read_test
        title 'SHALL support read of MedicationDispense'
        description %(
          The client demonstrates SHALL support for reading MedicationDispense.
        )

        input :medication_dispense_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `MedicationDispense` resource type, so support for US Core MedicationDispense Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core MedicationDispense Profile: `MedicationDispense/us-core-client-tests-medication-dispense`."
        end

        run do
          if parent_optional?
            omit_if medication_dispense_support.blank?, skip_message
          else
            skip_if medication_dispense_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_MEDICATION_DISPENSE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-medication-dispense')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
