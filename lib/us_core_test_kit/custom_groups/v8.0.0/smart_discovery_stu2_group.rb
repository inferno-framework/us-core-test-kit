require_relative '../smart_well_known_capabilities_test'

module USCoreTestKit
  module USCoreV800
    class USCoreDiscoverySTU2Group < SMARTAppLaunch::DiscoverySTU2Group
      id :us_core_v800_smart_discovery_stu2

      test from: :us_core_smart_well_known_capabilities
    end
  end
end
