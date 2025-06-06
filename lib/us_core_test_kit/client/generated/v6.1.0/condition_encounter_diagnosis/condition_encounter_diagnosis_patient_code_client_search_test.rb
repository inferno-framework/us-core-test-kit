# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ConditionEncounterDiagnosisPatientCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_condition_encounter_diagnosis_patient_code_client_search_test
        title 'SHOULD support patient + code search of ConditionEncounterDiagnosis'
        description %(
          The client demonstrates SHOULD support for searching patient + code on ConditionEncounterDiagnosis.
        )
        optional true

        input :condition_support,
              optional: true

        def required_params
          ["patient", "code"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Condition` resource type, so support for US Core Condition Encounter Diagnosis Profile is not expected."
        end

        def failure_message
          "No searches made for the `Condition` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if condition_support.blank?, skip_message
          else
            skip_if condition_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_CONDITION_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
