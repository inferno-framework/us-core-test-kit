# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class PatientClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v501_patient_client_support_test
        title 'Support Patient Resource Access'
        description %(
          
            This test checks whether the client made requests for the Patient FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-patient` for the US Core Patient Profile.
          
        )

        output :patient_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Patient`."
        end

        run do
          patient_read_requests = load_tagged_requests(READ_PATIENT_TAG)
          patient_search_requests = load_tagged_requests(SEARCH_PATIENT_TAG)
          patient_support = 
            patient_read_requests.length > 0 ||
            patient_search_requests.length > 0
          if parent_optional?
            omit_if !patient_support, skip_message
          else
            skip_if !patient_support, skip_message
          end

          (output patient_support:)
        end
      end
    end
  end
end
