require_relative '../smart_app_launch_group'
require_relative 'smart_discovery_stu2_group'

module USCoreTestKit
  module USCoreV800_BALLOT
    class SmartAppLaunchGroup < USCoreTestKit::SmartAppLaunchGroup
      id :us_core_v800_ballot_smart_app_launch

      groups[2].group from: :us_core_v800_smart_discovery_stu2
      groups[2].children[0] = groups[2].children.pop

      groups[3].group from: :us_core_v800_smart_discovery_stu2
      groups[3].children[0] = groups[3].children.pop
    end
  end
end
