# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class DiagnosticReportLabPatientCategoryLastupdatedClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_diagnostic_report_lab_patient_category_lastupdated_client_search_test
        title 'SHOULD support patient + category + _lastUpdated search of DiagnosticReportLab'
        description %(
          The client demonstrates SHOULD support for searching patient + category + _lastUpdated on DiagnosticReportLab.
        )
        optional true

        def required_params
          ["patient", "category", "_lastUpdated"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `DiagnosticReport` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `DiagnosticReport` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
