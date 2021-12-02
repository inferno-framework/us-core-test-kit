require_relative '../../reference_resolution_test'

module USCore
  class HeadCircumferenceReferenceResolutionTest < Inferno::Test
    include USCore::ReferenceResolutionTest

    title 'Every reference within Observation resources can be read'
    description %(
      This test will attempt to read the first 50 references found in the
      resources from the first search. The test will fail if Inferno fails to
      read any of those references.
    )

    id :head_circumference_reference_resolution_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:head_circumference_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
