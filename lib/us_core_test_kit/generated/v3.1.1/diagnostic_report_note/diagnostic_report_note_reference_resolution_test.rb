require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV311
    class DiagnosticReportNoteReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'Every reference within DiagnosticReport resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. The test will skip if Inferno fails to
        read any of those references.
      )

      id :us_core_v311_diagnostic_report_note_reference_resolution_test

      def resource_type
        'DiagnosticReport'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:diagnostic_report_note_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
