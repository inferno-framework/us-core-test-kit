require_relative '../smart_app_launch_group'
require_relative './smart_discovery_stu2_group'

module USCoreTestKit
  module USCoreV700
    class SmartAppLaunchGroup < USCoreTestKit::SmartAppLaunchGroup
      id :us_core_v700_smart_app_launch

      groups[2].group from: :us_core_v700_smart_discovery_stu2
      groups[2].children[0] = groups[2].children.pop

      groups.last.group from: :us_core_v700_smart_discovery_stu2
      groups.last.children[0] = groups.last.children.pop
    end
  end
end
