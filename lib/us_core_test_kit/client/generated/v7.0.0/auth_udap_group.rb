require 'udap_security_test_kit'
require_relative 'tags'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ClientAuthUDAPGroup < Inferno::TestGroup
        id :us_core_client_v700_auth_udap
        title 'Review UDAP Authentication Interactions'
        description %(
          During these tests, Inferno will verify that the client interacted with Inferno's
          simulated UDAP authorization server in a conformant manner when requesting access tokens
          and that the client under test was able to use provided access tokens to make US Core
          requests.
        )
        run_as_group

        test from: :udap_client_authorization_request_verification,
            id: :us_core_client_v700_authorization_udap_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v700 } }
        test from: :udap_client_token_request_ac_verification,
            id: :us_core_client_v700_token_udap_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v700 } }
        test from: :udap_client_token_use_verification,
              config: {
                options: { access_request_tags: [READ_REQUEST_TAG, SEARCH_REQUEST_TAG] }
              }
      end
    end
  end
end
