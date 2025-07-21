require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV610
    class QuestionnaireResponseIdSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for QuestionnaireResponse search by _id'
      description %(
A server SHALL support searching by
_id on the QuestionnaireResponse resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU6.1/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@51',
                            'hl7.fhir.us.core_6.1.0@52',
                            'hl7.fhir.us.core_6.1.0@55',
                            'hl7.fhir.us.core_6.1.0@58',
                            'hl7.fhir.us.core_6.1.0@61',
                            'hl7.fhir.us.core_6.1.0@62'

      id :us_core_v610_questionnaire_response__id_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'QuestionnaireResponse',
        search_param_names: ['_id'],
        possible_status_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:questionnaire_response_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
