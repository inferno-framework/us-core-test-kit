require_relative 'fhir_resource_navigation'

module USCoreTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      skip_if(*must_support_elements_missing?(resources, nil, metadata:))
    end
  end
end
