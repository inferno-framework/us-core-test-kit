require_relative '../../reference_resolution_test'

module USCore
  class BodyheightReferenceResolutionTest < Inferno::Test
    include USCore::ReferenceResolutionTest

    title 'Every reference within Observation resources can be read'
    description %(
      This test will attempt to read the first 50 references found in the
      resources from the first search. The test will fail if Inferno fails to
      read any of those references.
    )

    id :us_core_311_bodyheight_reference_resolution_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bodyheight_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
