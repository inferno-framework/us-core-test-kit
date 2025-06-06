# frozen_string_literal: true

require_relative 'specimen/specimen_client_read_test'
require_relative 'specimen/specimen_client_support_test'
require_relative 'specimen/specimen_patient_client_search_test'
require_relative 'specimen/specimen_id_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class SpecimenClientGroup < Inferno::TestGroup
        id :us_core_client_v700_specimen
        title 'Specimen'
        description %(
          
# Background

This test group verifies that the client can access Specimen data
conforming to the US Core Specimen Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Specimen FHIR resource type. However, if they
do support it, they must support the US Core Specimen Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Specimen resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-specimen`

## Searching
These tests will check that the client performed searches agains the
Specimen resource type with the following required parameters:

* _id

Inferno will also look for searches using the following optional parameters:

* patient


        )
        optional true
        run_as_group

        test from: :us_core_v700_specimen_client_support_test
        test from: :us_core_v700_specimen_client_read_test
        test from: :us_core_v700_specimen_patient_client_search_test
        test from: :us_core_v700_specimen_id_client_search_test
      end
    end
  end
end
