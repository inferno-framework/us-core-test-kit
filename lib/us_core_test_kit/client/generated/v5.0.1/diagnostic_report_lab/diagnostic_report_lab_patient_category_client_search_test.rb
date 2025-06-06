# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DiagnosticReportLabPatientCategoryClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_diagnostic_report_lab_patient_category_client_search_test
        title 'SHALL support patient + category search of DiagnosticReportLab'
        description %(
          The client demonstrates SHALL support for searching patient + category on DiagnosticReportLab.
        )
        optional false

        input :diagnostic_report_support,
              optional: true

        def required_params
          ["patient", "category"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `DiagnosticReport` resource type, so support for US Core DiagnosticReport Profile for Laboratory Results Reporting is not expected."
        end

        def failure_message
          "No searches made for the `DiagnosticReport` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if diagnostic_report_support.blank?, skip_message
          else
            skip_if diagnostic_report_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
