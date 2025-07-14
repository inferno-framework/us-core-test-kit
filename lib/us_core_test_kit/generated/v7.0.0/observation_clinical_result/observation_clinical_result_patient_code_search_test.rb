require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV700
    class ObservationClinicalResultPatientCodeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Observation search by patient + code'
      description %(
A server SHALL support searching by
patient + code on the Observation resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU7/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@51',
                            'hl7.fhir.us.core_7.0.0@52',
                            'hl7.fhir.us.core_7.0.0@55',
                            'hl7.fhir.us.core_7.0.0@58'

      id :us_core_v700_observation_clinical_result_patient_code_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
        search_param_names: ['patient', 'code'],
        possible_status_search: true,
        token_search_params: ['code']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_clinical_result_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
