require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV400
    class CarePlanReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'Every reference within CarePlan resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. The test will skip if Inferno fails to
        read any of those references.
      )

      id :us_core_v400_care_plan_reference_resolution_test

      def resource_type
        'CarePlan'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:care_plan_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
