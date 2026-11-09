# frozen_string_literal: true

require 'smart_app_launch_test_kit'

module USCoreTestKit
  module Client
    module USCoreClientV900
      class TokenEndpoint < SMARTAppLaunch::MockSMARTServer::TokenEndpoint
        def client_suite_id
          'us_core_client_v900'
        end
      end
    end
  end
end
