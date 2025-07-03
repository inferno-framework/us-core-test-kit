# frozen_string_literal: true

require_relative 'goal/goal_client_read_test'
require_relative 'goal/goal_patient_client_search_test'
require_relative 'goal/goal_patient_lifecycle_status_client_search_test'
require_relative 'goal/goal_patient_description_client_search_test'
require_relative 'goal/goal_patient_target_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV800
      class GoalClientGroup < Inferno::TestGroup
        id :us_core_client_v800_goal
        title 'Goal'
        description %(
          
# Background

This test group verifies that the client can access Goal data
conforming to the US Core Goal Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Goal FHIR resource type. However, if they
do support it, they must support the US Core Goal Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Goal resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-goal`

## Searching
These tests will check that the client performed searches agains the
Goal resource type with the following required parameters:

* patient

Inferno will also look for searches using the following optional parameters:

* patient + lifecycle-status
* patient + description
* patient + target-date


        )
        optional true
        run_as_group

        test from: :us_core_v800_goal_client_read_test
        test from: :us_core_v800_goal_patient_client_search_test
        test from: :us_core_v800_goal_patient_lifecycle_status_client_search_test
        test from: :us_core_v800_goal_patient_description_client_search_test
        test from: :us_core_v800_goal_patient_target_date_client_search_test
      end
    end
  end
end
