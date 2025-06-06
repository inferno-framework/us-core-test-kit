# frozen_string_literal: true

require 'smart_app_launch_test_kit'

module USCoreTestKit
  module Client
    module USCoreClientOptions
      SMART_APP_LAUNCH_PUBLIC = SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_PUBLIC
      SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC =
        SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
      SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC =
        SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
    end
  end
end
