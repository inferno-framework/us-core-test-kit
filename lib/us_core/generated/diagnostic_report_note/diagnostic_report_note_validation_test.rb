require_relative '../../validation_test'

module USCore
  class DiagnosticReportNoteValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'DiagnosticReport resources returned during previous tests conform to the US Core DiagnosticReport Profile for Report and Note exchange'
    # description ''

    id :diagnostic_report_note_validation_test

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_note_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note')
    end
  end
end
