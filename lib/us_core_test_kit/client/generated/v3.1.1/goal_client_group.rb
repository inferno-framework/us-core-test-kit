# frozen_string_literal: true

require_relative 'goal/goal_client_read_test'
require_relative 'goal/goal_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class GoalClientGroup < Inferno::TestGroup
        id :us_core_client_v311_goal

        title 'Goal'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Goal queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-goal`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient

        )

        run_as_group

        test from: :us_core_v311_goal_client_read_test
        test from: :us_core_v311_goal_patient_client_search_test
      end
    end
  end
end
