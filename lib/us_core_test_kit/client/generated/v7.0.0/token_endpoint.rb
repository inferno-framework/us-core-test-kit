# frozen_string_literal: true

require 'udap_security_test_kit'
require 'smart_app_launch_test_kit'
require_relative 'urls'
require_relative 'tags'

module USCoreTestKit
  module Client
    module USCoreClientV700
      module MockUdapSmartServer
        class TokenEndpoint < Inferno::DSL::SuiteEndpoint
          include SMARTAppLaunch::MockSMARTServer::SMARTTokenResponseCreation
          include UDAPSecurityTestKit::MockUDAPServer::UDAPTokenResponseCreation
          include URLs

          def test_run_identifier
            case request.params[:grant_type]
            when UDAPSecurityTestKit::CLIENT_CREDENTIALS_TAG
              UDAPSecurityTestKit::MockUDAPServer.client_id_from_client_assertion(request.params[:client_assertion])
            when UDAPSecurityTestKit::AUTHORIZATION_CODE_TAG
              UDAPSecurityTestKit::MockUDAPServer.issued_token_to_client_id(request.params[:code])
            when UDAPSecurityTestKit::REFRESH_TOKEN_TAG
              UDAPSecurityTestKit::MockUDAPServer.issued_token_to_client_id(
                UDAPSecurityTestKit::MockUDAPServer.refresh_token_to_authorization_code(request.params[:refresh_token])
              )
            end
          end

          def make_response
            if request.params[:udap].present?
              case request.params[:grant_type]
              when UDAPSecurityTestKit::AUTHORIZATION_CODE_TAG
                make_udap_authorization_code_token_response
              when UDAPSecurityTestKit::REFRESH_TOKEN_TAG
                make_udap_refresh_token_response
              else
                UDAPSecurityTestKit::MockUDAPServer.update_response_for_invalid_assertion(
                  response,
                  "unsupported grant_type: #{request.params[:grant_type]}"
                )
              end
            else
              suite_options_list = Inferno::Repositories::TestSessions.new.find(result.test_session_id)&.suite_options
              suite_options_hash = suite_options_list&.map { |option| [option.id, option.value] }&.to_h
              smart_authentication_approach =
                SMARTAppLaunch::SMARTClientOptions.smart_authentication_approach(suite_options_hash)
              
              case request.params[:grant_type]
              when SMARTAppLaunch::AUTHORIZATION_CODE_TAG
                make_smart_authorization_code_token_response(smart_authentication_approach)
              when SMARTAppLaunch::REFRESH_TOKEN_TAG
                make_smart_refresh_token_response(smart_authentication_approach)
              else
                SMARTAppLaunch::MockSMARTServer.update_response_for_invalid_assertion(
                  response,
                  "unsupported grant_type: #{request.params[:grant_type]}"
                )
              end
            end
          end

          def update_result
            nil # never update for now
          end

          def tags
            tags = [UDAPSecurityTestKit::TOKEN_TAG]
            tags << (request.params[:udap].present? ? UDAPSecurityTestKit::UDAP_TAG : SMARTAppLaunch::SMART_TAG)
            if [UDAPSecurityTestKit::CLIENT_CREDENTIALS_TAG, 
                UDAPSecurityTestKit::AUTHORIZATION_CODE_TAG, 
                UDAPSecurityTestKit::REFRESH_TOKEN_TAG].include?(request.params[:grant_type])
              tags << request.params[:grant_type]
            end

            tags
          end
        end
      end
    end
  end
end
