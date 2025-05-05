# frozen_string_literal: true

require_relative 'pulse_oximetry/pulse_oximetry_client_read_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_code_client_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_category_client_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_category_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class PulseOximetryClientGroup < Inferno::TestGroup
        id :us_core_client_v400_pulse_oximetry

        title 'Observation Pulse Oximetry'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-pulse-oximetry`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category
* patient + category + date

        )

        run_as_group

        test from: :us_core_v400_pulse_oximetry_client_read_test
        test from: :us_core_v400_pulse_oximetry_patient_code_client_search_test
        test from: :us_core_v400_pulse_oximetry_patient_category_client_search_test
        test from: :us_core_v400_pulse_oximetry_patient_category_date_client_search_test
      end
    end
  end
end
