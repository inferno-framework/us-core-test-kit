require_relative '../../search_test'

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

    input :patient_id, default: '85'

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_note_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'code': search_param_value('code'),
        'date': search_param_value('effective')
      }
    end

    run do
      perform_search_test
    end
  end
end
