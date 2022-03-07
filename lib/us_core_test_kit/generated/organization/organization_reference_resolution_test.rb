require_relative '../../reference_resolution_test'

module USCoreTestKit
  class OrganizationReferenceResolutionTest < Inferno::Test
    include USCoreTestKit::ReferenceResolutionTest

    title 'Every reference within Organization resources can be read'
    description %(
      This test will attempt to read MustSupport references found in the
      resources from the first search. The test will skip if Inferno fails to
      read any of those references.
    )

    id :us_core_311_organization_reference_resolution_test

    def resource_type
      'Organization'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:organization_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
