require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV501
    class ConditionProblemsHealthConcernsReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within Condition resources can be read'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.  Elements which may provide
        external references include:

        * Condition.subject
      )

      id :us_core_v501_condition_problems_health_concerns_reference_resolution_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:condition_problems_health_concerns_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
