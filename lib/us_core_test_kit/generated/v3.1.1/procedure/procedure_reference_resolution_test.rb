require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV311
    class ProcedureReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within Procedure resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. This test will look through the Procedure resources
        found previously for the following must support elements:

        * Procedure.subject
      )

      id :us_core_v311_procedure_reference_resolution_test

      def resource_type
        'Procedure'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
