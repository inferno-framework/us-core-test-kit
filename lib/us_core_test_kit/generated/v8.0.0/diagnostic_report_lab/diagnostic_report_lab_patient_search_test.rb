require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class DiagnosticReportLabPatientSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for DiagnosticReport search by patient'
      description %(
A server SHALL support searching by
patient on the DiagnosticReport resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU8/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@51',
                            'hl7.fhir.us.core_8.0.0@52',
                            'hl7.fhir.us.core_8.0.0@55',
                            'hl7.fhir.us.core_8.0.0@58'

      id :us_core_v800_diagnostic_report_lab_patient_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DiagnosticReport',
        search_param_names: ['patient'],
        possible_status_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:diagnostic_report_lab_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
