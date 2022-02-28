require_relative '../../reference_resolution_test'

module USCoreTestKit
  class GoalReferenceResolutionTest < Inferno::Test
    include USCoreTestKit::ReferenceResolutionTest

    title 'Every reference within Goal resources can be read'
    description %(
      This test will attempt to read the first 50 references found in the
      resources from the first search. The test will fail if Inferno fails to
      read any of those references.
    )

    id :us_core_311_goal_reference_resolution_test

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
