require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV700
    class PractitionerRoleSpecialtySearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for PractitionerRole search by specialty'
      description %(
A server SHALL support searching by
specialty on the PractitionerRole resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU7/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@51', 'hl7.fhir.us.core_7.0.0@52',
                            'hl7.fhir.us.core_7.0.0@55', 'hl7.fhir.us.core_6.1.0@58'

      id :us_core_v700_practitioner_role_specialty_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'PractitionerRole',
        search_param_names: ['specialty'],
        token_search_params: ['specialty']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
