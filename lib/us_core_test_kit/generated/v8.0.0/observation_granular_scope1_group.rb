require_relative './granular_scope_tests/observation/observation_patient_code_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_patient_category_lastupdated_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_patient_category_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_patient_category_status_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_patient_category_date_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_patient_code_date_granular_scope_search_test'
require_relative './granular_scope_tests/observation/observation_granular_scope_read_test'

module USCoreTestKit
  module USCoreV800
    class ObservationGranularScope1Group < Inferno::TestGroup
      title 'Observation Granular Scope Tests'
      short_description 'Verify support for the server capabilities required by the US Core Observation ADI Documentation Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history`

      )

      id :us_core_v800_observation_granular_scope_1_group
      run_as_group

    
      test from: :us_core_v800_Observation_patient_code_granular_scope_search_test
      test from: :us_core_v800_Observation_patient_category__lastUpdated_granular_scope_search_test
      test from: :us_core_v800_Observation_patient_category_granular_scope_search_test
      test from: :us_core_v800_Observation_patient_category_status_granular_scope_search_test
      test from: :us_core_v800_Observation_patient_category_date_granular_scope_search_test
      test from: :us_core_v800_Observation_patient_code_date_granular_scope_search_test
      test from: :us_core_v800_Observation_granular_scope_read_test
    end
  end
end
