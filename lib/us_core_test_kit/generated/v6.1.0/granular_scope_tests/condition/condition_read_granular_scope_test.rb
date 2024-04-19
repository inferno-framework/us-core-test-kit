require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV610
    class ConditionReadGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for Condition read based on granular scopes'
      description %(
This test repeats all Condition reads 
and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v610_Condition_read_granular_scope_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        run_scope_check_read_test
      end
    end
  end
end
