require 'smart_app_launch_test_kit'
require_relative 'tags'

module USCoreTestKit
  module Client
    module USCoreClientV800
      class AuthSMARTPublicGroup < Inferno::TestGroup
        id :us_core_client_v800_auth_smart_alp
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
            id: :us_core_client_v800_authorization_smart_alp_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v800 } }
        test from: :smart_client_token_request_alp_verification,
            id: :us_core_client_v800_token_smart_alp_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v800 } }
        test from: :smart_client_token_use_verification,
            config: { options: { access_request_tags: [READ_REQUEST_TAG, SEARCH_REQUEST_TAG] } }
      end
    end
  end
end
