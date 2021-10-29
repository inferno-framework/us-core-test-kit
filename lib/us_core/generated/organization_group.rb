require_relative 'organization/organization_read_test'

module USCore
  class OrganizationGroup < Inferno::TestGroup
    title 'Organization Tests'
    # description ''

    id :organization

    test from: :organization_read_test
  end
end
