# frozen_string_literal: true

require 'udap_security_test_kit'
require 'smart_app_launch_test_kit'
require_relative 'urls'
require_relative 'tags'
require_relative '../../us_core_client_options'

module USCoreTestKit
  module Client
    module USCoreClientV700
      module MockUdapSmartServer
        class AuthorizationEndpoint < Inferno::DSL::SuiteEndpoint
          include SMARTAppLaunch::MockSMARTServer::SMARTAuthorizationResponseCreation
          include UDAPSecurityTestKit::MockUDAPServer::UDAPAuthorizationResponseCreation
          include USCoreClientOptions

          def test_run_identifier
            request.params[:client_id]
          end

          def suite_options
            @suite_options ||=
              Inferno::Repositories::TestSessions.new.find(result.test_session_id)
                &.suite_options&.map { |so| [so.id, so.value] }&.to_h
          end

          def make_response
            if selected_security_ig(suite_options) == UDAPSecurityTestKit::UDAP_TAG
              make_udap_authorization_response
            else
              make_smart_authorization_response
            end
          end

          def update_result
            nil # never update for now
          end

          def tags
            tags = [UDAPSecurityTestKit::AUTHORIZATION_TAG, UDAPSecurityTestKit::AUTHORIZATION_CODE_TAG]
            tags <<
              if selected_security_ig(suite_options) == UDAPSecurityTestKit::UDAP_TAG
                UDAPSecurityTestKit::UDAP_TAG
              else
                SMARTAppLaunch::SMART_TAG
              end

            tags
          end
        end
      end
    end
  end
end
