# frozen_string_literal: true

require_relative 'family_member_history/family_member_history_client_read_test'
require_relative 'family_member_history/family_member_history_patient_client_search_test'
require_relative 'family_member_history/family_member_history_patient_code_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV900
      class FamilyMemberHistoryClientGroup < Inferno::TestGroup
        id :us_core_client_v900_family_member_history
        title 'FamilyMemberHistory'
        description %(
          Verify that the client reads FamilyMemberHistory/us-core-client-tests-family-member-history
          and searches FamilyMemberHistory by patient. The recommended patient + code
          search is optional. This profile group follows the suite's existing optional-profile
          policy; at least one profile group must pass overall.
        )
        optional true
        run_as_group

        test from: :us_core_v900_family_member_history_client_read_test
        test from: :us_core_v900_family_member_history_patient_client_search_test
        test from: :us_core_v900_family_member_history_patient_code_client_search_test
      end
    end
  end
end
