require_relative '../../read_test'

module USCore
  class CarePlanReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct CarePlan resource from CarePlan read interaction'
    description 'A server SHALL support the CarePlan read interaction.'

    id :us_core_311_care_plan_read_test

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= {}
    end

    run do
      perform_read_test(all_scratch_resources)
    end
  end
end
