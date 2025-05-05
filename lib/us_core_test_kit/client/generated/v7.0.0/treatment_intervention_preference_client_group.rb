# frozen_string_literal: true

require_relative 'treatment_intervention_preference/treatment_intervention_preference_client_read_test'
require_relative 'treatment_intervention_preference/treatment_intervention_preference_patient_code_client_search_test'
require_relative 'treatment_intervention_preference/treatment_intervention_preference_patient_category_date_client_search_test'
require_relative 'treatment_intervention_preference/treatment_intervention_preference_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class TreatmentInterventionPreferenceClientGroup < Inferno::TestGroup
        id :us_core_client_v700_treatment_intervention_preference

        title 'Observation Treatment Intervention Preference'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-treatment-intervention-preference`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category + date
* patient + category

        )

        run_as_group

        test from: :us_core_v700_treatment_intervention_preference_client_read_test
        test from: :us_core_v700_treatment_intervention_preference_patient_code_client_search_test
        test from: :us_core_v700_treatment_intervention_preference_patient_category_date_client_search_test
        test from: :us_core_v700_treatment_intervention_preference_patient_category_client_search_test
      end
    end
  end
end
