require_relative '../read_test'

module USCore
  class OrganizationReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Organization resource from Organization read interaction'
    description 'A server SHALL support the Organization read interaction.'

    id :organization_read_test

    def resource_type
      'Organization'
    end

    run do
      perform_read_test(scratch[:organization_resources])
    end
  end
end
