# frozen_string_literal: true

require_relative 'diagnostic_report_lab/diagnostic_report_lab_client_read_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_client_support_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_category_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_status_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_category_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_code_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_date_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_code_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_code_date_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_category_date_client_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class DiagnosticReportLabClientGroup < Inferno::TestGroup
        id :us_core_client_v400_diagnostic_report_lab
        title 'DiagnosticReport for Laboratory Results Reporting'
        description %(
          
# Background

This test group verifies that the client can access DiagnosticReport data
conforming to the US Core DiagnosticReport Profile for Laboratory Results Reporting.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the DiagnosticReport FHIR resource type. However, if they
do support it, they must support the US Core DiagnosticReport Profile for Laboratory Results Reporting and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
DiagnosticReport resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-diagnostic-report-lab`

## Searching
These tests will check that the client performed searches agains the
DiagnosticReport resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient + category
* status
* patient
* category
* code
* date
* patient + code
* patient + code + date
* patient + category + date
* patient + status


        )
        optional true
        run_as_group

        test from: :us_core_v400_diagnostic_report_lab_client_support_test
        test from: :us_core_v400_diagnostic_report_lab_client_read_test
        test from: :us_core_v400_diagnostic_report_lab_patient_category_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_status_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_patient_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_category_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_code_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_date_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_patient_code_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_patient_code_date_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_patient_category_date_client_search_test
        test from: :us_core_v400_diagnostic_report_lab_patient_status_client_search_test
      end
    end
  end
end
