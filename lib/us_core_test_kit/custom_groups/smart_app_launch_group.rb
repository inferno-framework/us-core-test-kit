require 'smart_app_launch_test_kit'
require_relative '../us_core_options'
require_relative 'smart_ehr_launch_stu1'
require_relative 'smart_ehr_launch_stu2'
require_relative 'smart_ehr_launch_stu2_2'
require_relative 'smart_standalone_launch_stu1_group'
require_relative 'smart_standalone_launch_stu2_group'
require_relative 'smart_standalone_launch_stu2_2_group'

module USCoreTestKit
  class SmartAppLaunchGroup < Inferno::TestGroup
    id :us_core_smart_app_launch
    title 'SMART App Launch'

    group from: :us_core_smart_standalone_launch_stu1,
          required_suite_options: USCoreOptions::SMART_1_REQUIREMENT,
          optional: true

    group from: :us_core_smart_ehr_launch_stu1,
          required_suite_options: USCoreOptions::SMART_1_REQUIREMENT,
          optional: true

    group from: :us_core_smart_standalone_launch_stu2,
          required_suite_options: USCoreOptions::SMART_2_REQUIREMENT,
          optional: true

    group from: :us_core_smart_ehr_launch_stu2,
          required_suite_options: USCoreOptions::SMART_2_REQUIREMENT,
          optional: true

    group from: :us_core_smart_standalone_launch_stu2_2,
          required_suite_options: USCoreOptions::SMART_2_2_REQUIREMENT,
          optional: true

    group from: :us_core_smart_ehr_launch_stu2_2,
          required_suite_options: USCoreOptions::SMART_2_2_REQUIREMENT,
          optional: true
  end
end
