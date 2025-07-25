require 'smart_app_launch_test_kit'
require_relative '../../us_core_client_options'
require_relative 'registration/configuration_display_smart_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class RegistrationGroup < Inferno::TestGroup
        id :us_core_client_v501_registration
        title 'Client Registration'
        description %(
          During these tests, the client will register with Inferno's simulated US Core Server,
          including configuration of the system under test to hit the correct endpoints and
          enable authentication and authorization of US Core requests. Inferno will verify
          that the registration details are conformant.
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
        test from: :us_core_client_v501_reg_config_smart_display,
              id: :us_core_client_v501_reg_config_smart_alca_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        test from: :us_core_client_v501_reg_config_smart_display,
              id: :us_core_client_v501_reg_config_smart_alcs_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        test from: :us_core_client_v501_reg_config_smart_display,
              id: :us_core_client_v501_reg_config_smart_alp_display,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }
      end
    end
  end
end
