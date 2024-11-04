require_relative '../smart_app_launch_group'
require_relative 'smart_discovery_stu2_2_group'

module USCoreTestKit
  module USCoreV700
    class SmartAppLaunchSTU22Group < USCoreTestKit::SmartAppLaunchGroup
      id :us_core_v700_smart_app_launch_stu2_2

      groups[4].group from: :us_core_v700_smart_discovery_stu2_2
      groups[4].children[0] = groups[4].children.pop

      groups.last.group from: :us_core_v700_smart_discovery_stu2_2
      groups.last.children[0] = groups.last.children.pop
    end
  end
end
