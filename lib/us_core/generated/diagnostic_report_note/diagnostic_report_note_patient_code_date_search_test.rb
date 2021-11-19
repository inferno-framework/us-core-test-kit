require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DiagnosticReportNotePatientCodeDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by patient + code + date'
    description %(
      A server SHOULD support searching by patient + code + date on the DiagnosticReport resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :diagnostic_report_note_patient_code_date_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'DiagnosticReport',
        search_param_names: ['patient', 'code', 'date'],
        possible_status_search: true,
        token_search_params: ['code']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:diagnostic_report_note_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
