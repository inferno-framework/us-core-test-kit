require_relative '../smart_well_known_capabilities_test'

module USCoreTestKit
  module USCoreV800
    class USCoreDiscoverySTU22Group < SMARTAppLaunch::DiscoverySTU22Group
      id :us_core_v800_smart_discovery_stu2_2

      test from: :us_core_smart_well_known_capabilities
    end
  end
end
