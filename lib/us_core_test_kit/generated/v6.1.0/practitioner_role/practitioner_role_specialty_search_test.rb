require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV610
    class PractitionerRoleSpecialtySearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for PractitionerRole search by specialty'
      description %(
A server SHALL support searching by
specialty on the PractitionerRole resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v6.1.0.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU6.1/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@51',
                            'hl7.fhir.us.core_6.1.0@52',
                            'hl7.fhir.us.core_6.1.0@55',
                            'hl7.fhir.us.core_6.1.0@58',
                            'hl7.fhir.us.core_6.1.0@61',
                            'hl7.fhir.us.core_6.1.0@62'

      id :us_core_v610_practitioner_role_specialty_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'PractitionerRole',
        search_param_names: ['specialty'],
        saves_delayed_references: true,
        token_search_params: ['specialty'],
        test_post_search: true
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
