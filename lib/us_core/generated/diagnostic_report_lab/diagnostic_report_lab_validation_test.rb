require_relative '../../validation_test'

module USCore
  class DiagnosticReportLabValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'DiagnosticReport resources returned during previous tests conform to the US Core DiagnosticReport Profile for Laboratory Results Reporting'
    # description ''

    id :diagnostic_report_lab_validation_test

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_lab_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab')
    end
  end
end
