# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV900
      class FamilyMemberHistoryClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v900_family_member_history_client_read_test
        title 'SHALL support read of FamilyMemberHistory'
        description %(
          The client demonstrates SHALL support for reading FamilyMemberHistory.
        )

        def skip_message
          "Inferno did not receive any read requests for the `FamilyMemberHistory` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core FamilyMemberHistory Profile: `FamilyMemberHistory/us-core-client-tests-family-member-history`."
        end

        run do
          requests = load_tagged_requests(READ_FAMILY_MEMBER_HISTORY_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-family-member-history')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
