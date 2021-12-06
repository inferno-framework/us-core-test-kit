require_relative '../../reference_resolution_test'

module USCore
  class PractitionerReferenceResolutionTest < Inferno::Test
    include USCore::ReferenceResolutionTest

    title 'Every reference within Practitioner resources can be read'
    description %(
      This test will attempt to read the first 50 references found in the
      resources from the first search. The test will fail if Inferno fails to
      read any of those references.
    )

    id :us_core_311_practitioner_reference_resolution_test

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
