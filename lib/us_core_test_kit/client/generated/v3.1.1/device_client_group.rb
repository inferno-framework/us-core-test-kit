# frozen_string_literal: true

require_relative 'device/device_client_read_test'
require_relative 'device/device_client_support_test'
require_relative 'device/device_patient_client_search_test'
require_relative 'device/device_type_client_search_test'
require_relative 'device/device_patient_type_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class DeviceClientGroup < Inferno::TestGroup
        id :us_core_client_v311_device
        title 'Implantable Device'
        description %(
          
# Background

This test group verifies that the client can access Device data
conforming to the US Core Implantable Device Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Device FHIR resource type. However, if they
do support it, they must support the US Core Implantable Device Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Device resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-device`

## Searching
These tests will check that the client performed searches agains the
Device resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient
* type
* patient + type


        )
        optional true
        run_as_group

        test from: :us_core_v311_device_client_support_test
        test from: :us_core_v311_device_client_read_test
        test from: :us_core_v311_device_patient_client_search_test
        test from: :us_core_v311_device_type_client_search_test
        test from: :us_core_v311_device_patient_type_client_search_test
      end
    end
  end
end
