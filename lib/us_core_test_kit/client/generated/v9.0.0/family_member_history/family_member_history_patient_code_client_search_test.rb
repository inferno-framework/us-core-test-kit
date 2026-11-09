# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV900
      class FamilyMemberHistoryPatientCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v900_family_member_history_patient_code_client_search_test
        title 'SHOULD support patient + code search of FamilyMemberHistory'
        description %(
          The client demonstrates SHOULD support for searching patient + code on FamilyMemberHistory.
        )
        optional true

        def required_params
          ["patient", "code"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `FamilyMemberHistory` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `FamilyMemberHistory` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_FAMILY_MEMBER_HISTORY_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
