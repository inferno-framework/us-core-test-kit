# frozen_string_literal: true

require_relative 'patient/patient_client_read_test'
require_relative 'patient/patient_id_client_search_test'
require_relative 'patient/patient_identifier_client_search_test'
require_relative 'patient/patient_name_client_search_test'
require_relative 'patient/patient_birthdate_name_client_search_test'
require_relative 'patient/patient_gender_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class PatientClientGroup < Inferno::TestGroup
        id :us_core_client_v501_patient

        title 'Patient'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Patient queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-patient`

## Searching
This sequence will check that the client performed searches with the following parameters:

* _id
* identifier
* name
* birthdate + name
* gender + name

        )

        run_as_group

        test from: :us_core_v501_patient_client_read_test
        test from: :us_core_v501_patient_id_client_search_test
        test from: :us_core_v501_patient_identifier_client_search_test
        test from: :us_core_v501_patient_name_client_search_test
        test from: :us_core_v501_patient_birthdate_name_client_search_test
        test from: :us_core_v501_patient_gender_name_client_search_test
      end
    end
  end
end
