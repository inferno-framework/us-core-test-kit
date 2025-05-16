require 'smart_app_launch_test_kit'
require_relative 'tags'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class AuthSMARTConfidentialSymmetricGroup < Inferno::TestGroup
        id :us_core_client_v400_auth_smart_alcs
        title 'Review Authentication Interactions'
        description %(
          During these tests, Inferno will verify that the client interacted with Inferno's
          simulated SMART authorization server in a conformant manner when requesting access tokens
          and that the client under test was able to use provided access tokens to make US Core
          requests.
        )
        run_as_group

        # smart auth verification
        test from: :smart_client_authorization_request_verification,
            id: :us_core_client_v400_authorization_smart_alcs_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v400 } }
        test from: :smart_client_token_request_alcs_verification,
            id: :us_core_client_v400_token_smart_alcs_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v400 } }
        test from: :smart_client_token_use_verification,
            config: { options: { access_request_tags: [READ_REQUEST_TAG, SEARCH_REQUEST_TAG] } }
      end
    end
  end
end
