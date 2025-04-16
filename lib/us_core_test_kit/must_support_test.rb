require_relative 'fhir_resource_navigation'

module USCoreTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def exclude_uscdi_only_test?
      config.options[:exclude_uscdi_only_test] == true
    end

    def must_support_extensions
      if exclude_uscdi_only_test?
        metadata.must_supports[:extensions].reject{ |extension| extension[:uscdi_only] }
      else
        metadata.must_supports[:extensions]
      end
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      if (self.id.start_with?('g10_certification'))
        metadata
      end

      skip { assert_must_support_elements_present(resources, nil, metadata:) }
    end
  end
end
