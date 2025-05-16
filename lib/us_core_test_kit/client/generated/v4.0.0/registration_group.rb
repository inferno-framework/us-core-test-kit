require 'udap_security_test_kit'
require 'smart_app_launch_test_kit'
require_relative '../../us_core_client_options'
require_relative 'registration/configuration_display_smart_test'
require_relative 'registration/configuration_display_udap_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class RegistrationGroup < Inferno::TestGroup
        id :us_core_client_v400_registration
        title 'Client Registration'
        description %(
          Register the client under test with Inferno's simulated US Core Server,
          including configuration of the system under test to hit the correct endpoints and
          enable authentication and authorization of US Core requests.
        )
        run_as_group

        # smart registration tests
        test from: :smart_client_registration_alca_verification,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        test from: :smart_client_registration_alcs_verification,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        test from: :smart_client_registration_alp_verification,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }
        test from: :us_core_client_v400_reg_config_smart_display,
              id: :us_core_client_v400_reg_config_smart_alca_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        test from: :us_core_client_v400_reg_config_smart_display,
              id: :us_core_client_v400_reg_config_smart_alcs_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        test from: :us_core_client_v400_reg_config_smart_display,
              id: :us_core_client_v400_reg_config_smart_alp_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }

        # udap registration tests
        test from: :udap_client_registration_interaction,
            id: :us_core_client_v400_reg_udap_interaction,
            config: { options: { endpoint_suite_id: :us_core_client_v400 } },
            required_suite_options: {
              client_type: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
            }
        test from: :udap_client_registration_ac_verification,
            id: :us_core_client_v400_reg_udap_verification,
            config: { options: { endpoint_suite_id: :us_core_client_v400 } },
            required_suite_options: {
              client_type: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
            }
        test from: :us_core_client_v400_reg_config_udap_display,
              required_suite_options: {
                client_type: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
              }
      end
    end
  end
end
