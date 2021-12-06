require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DiagnosticReportLabPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by patient'
    description %(
A server SHALL support searching by
patient on the DiagnosticReport resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_diagnostic_report_lab_patient_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'DiagnosticReport',
        search_param_names: ['patient'],
        possible_status_search: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:diagnostic_report_lab_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
