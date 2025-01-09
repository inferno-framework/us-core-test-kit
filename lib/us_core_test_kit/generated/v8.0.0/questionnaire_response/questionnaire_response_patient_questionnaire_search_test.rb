require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class QuestionnaireResponsePatientQuestionnaireSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for QuestionnaireResponse search by patient + questionnaire'
      description %(
A server SHOULD support searching by
patient + questionnaire on the QuestionnaireResponse resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/2025Jan/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_questionnaire_response_patient_questionnaire_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'QuestionnaireResponse',
        search_param_names: ['patient', 'questionnaire'],
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
