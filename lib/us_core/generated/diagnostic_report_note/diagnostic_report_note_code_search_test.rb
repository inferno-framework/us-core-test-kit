require_relative '../../search_test'

module USCore
  class DiagnosticReportNoteCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by code'
    description %(
      A server MAY support searching by code on the DiagnosticReport resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :diagnostic_report_note_code_search_test

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_note_resources] ||= []
    end

    def search_params
      {
        'code': search_param_value('code')
      }
    end

    run do
      perform_search_test
    end
  end
end
