require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_read_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DocumentReferenceGranularScopeReadTest < Inferno::Test
      include USCoreTestKit::GranularScopeReadTest

      title 'Server filters results for DocumentReference reads based on granular scopes'
      description %(
This test attempts DocumentReference reads 
and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_DocumentReference_granular_scope_read_test

      def resource_type
        'DocumentReference'
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
