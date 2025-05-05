# frozen_string_literal: true

require_relative 'encounter/encounter_client_read_test'
require_relative 'encounter/encounter_patient_client_search_test'
require_relative 'encounter/encounter_id_client_search_test'
require_relative 'encounter/encounter_date_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class EncounterClientGroup < Inferno::TestGroup
        id :us_core_client_v700_encounter

        title 'Encounter'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Encounter queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-encounter`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient
* _id
* date + patient

        )

        run_as_group

        test from: :us_core_v700_encounter_client_read_test
        test from: :us_core_v700_encounter_patient_client_search_test
        test from: :us_core_v700_encounter_id_client_search_test
        test from: :us_core_v700_encounter_date_patient_client_search_test
      end
    end
  end
end
