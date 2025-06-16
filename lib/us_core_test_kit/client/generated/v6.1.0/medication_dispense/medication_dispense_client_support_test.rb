# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class MedicationDispenseClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_medication_dispense_client_support_test
        title 'Support MedicationDispense Resource Access'
        description %(
          
            This test checks whether the client made requests for the MedicationDispense FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-medication-dispense` for the US Core MedicationDispense Profile.
          
        )

        output :medication_dispense_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `MedicationDispense`."
        end

        run do
          medication_dispense_read_requests = load_tagged_requests(READ_MEDICATION_DISPENSE_TAG)
          medication_dispense_search_requests = load_tagged_requests(SEARCH_MEDICATION_DISPENSE_TAG)
          medication_dispense_support = 
            medication_dispense_read_requests.length > 0 ||
            medication_dispense_search_requests.length > 0
          if parent_optional?
            omit_if !medication_dispense_support, skip_message
          else
            skip_if !medication_dispense_support, skip_message
          end

          (output medication_dispense_support:)
        end
      end
    end
  end
end
