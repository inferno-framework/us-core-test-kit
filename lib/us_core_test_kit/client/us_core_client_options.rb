# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require 'udap_security_test_kit'

module USCoreTestKit
  module Client
    module USCoreClientOptions
      SMART_APP_LAUNCH_PUBLIC = SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_PUBLIC
      SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC =
        SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
      SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC =
        SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
      UDAP_AUTHORIZATION_CODE = 
        UDAPSecurityTestKit::UDAPClientOptions::UDAP_AUTHORIZATION_CODE

      def selected_security_ig(suite_options)
        if suite_options[:client_type].include?(UDAPSecurityTestKit::UDAP_TAG)
          UDAPSecurityTestKit::UDAP_TAG
        else 
          SMARTAppLaunch::SMART_TAG
        end
      end
    end
  end
end
