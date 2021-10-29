require_relative '../read_test'

module USCore
  class CarePlanReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct CarePlan resource from CarePlan read interaction'
    description 'A server SHALL support the CarePlan read interaction.'

    id :care_plan_read_test

    def resource_type
      'CarePlan'
    end

    run do
      perform_read_test(scratch[:care_plan_resources])
    end
  end
end
