require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_read_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DiagnosticReportGranularScopeReadTest < Inferno::Test
      include USCoreTestKit::GranularScopeReadTest

      title 'Server filters results for DiagnosticReport reads based on granular scopes'
      description %(
This test attempts DiagnosticReport reads 
and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_DiagnosticReport_granular_scope_read_test

      def resource_type
        'DiagnosticReport'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        run_scope_read_test
      end
    end
  end
end
