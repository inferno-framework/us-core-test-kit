require_relative 'family_member_history/family_member_history_patient_search_test'
require_relative 'family_member_history/family_member_history_patient_code_search_test'
require_relative 'family_member_history/family_member_history_read_test'
require_relative 'family_member_history/family_member_history_provenance_revinclude_search_test'
require_relative 'family_member_history/family_member_history_validation_test'
require_relative 'family_member_history/family_member_history_must_support_test'
require_relative 'family_member_history/family_member_history_reference_resolution_test'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryGroup < Inferno::TestGroup
      title 'FamilyMemberHistory Tests'
      short_description 'Verify support for the server capabilities required by the US Core FamilyMemberHistory Profile.'
      id :us_core_v900_family_member_history
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'family_member_history', 'metadata.yml'), aliases: true))
      end

      test from: :us_core_v900_family_member_history_patient_search_test
      test from: :us_core_v900_family_member_history_patient_code_search_test
      test from: :us_core_v900_family_member_history_read_test
      test from: :us_core_v900_family_member_history_provenance_revinclude_search_test
      test from: :us_core_v900_family_member_history_validation_test
      test from: :us_core_v900_family_member_history_must_support_test
      test from: :us_core_v900_family_member_history_reference_resolution_test
    end
  end
end
