module USCoreTestKit
  module MustSupportTest
    include Inferno::DSL::FHIRResourceNavigation
    extend Forwardable

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      skip { assert_must_support_elements_present(resources, nil, metadata:) }
    end
  end
end
