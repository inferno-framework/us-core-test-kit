# frozen_string_literal: true

require_relative '../../lib/us_core_test_kit/generated/v8.0.0/encounter/interpreter_required_extension_test'

RSpec.describe USCoreTestKit::USCoreV800::InterpreterRequiredExtensionTest do
  let(:suite_id) { 'us_core_v800' }
  let(:url) { 'http://example.com/fhir' }
  let(:test) { described_class }

  let(:patient) do
    FHIR::Patient.new(
      id: 123,
      extension: [{
        url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed',
        valueCoding: {
          system: 'http://snomed.info/sct',
          version: 'http://snomed.info/sct/731000124108',
          code: '373066001'
        }
      }]
    )
  end

  let(:patient2) do
    FHIR::Patient.new(
      id: 456
    )
  end

  let(:encounter) do
    FHIR::Encounter.new(
      id: 456,
      extension: [{
        url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed',
        valueCoding: {
          system: 'http://snomed.info/sct',
          version: 'http://snomed.info/sct/731000124108',
          code: '373066001'
        }
      }],
      subject: {
        reference: 'Patient/123'
      }
    )
  end

  let(:encounter_no_extension) do
    FHIR::Encounter.new(
      id: 789,
      subject: {
        reference: 'Patient/123'
      }
    )
  end

  describe 'interpreter required extension test' do
    before do
      allow_any_instance_of(test)
        .to receive(:scratch_patient_resources).and_return(
          {
            all: [patient2, patient]
          }
        )

      allow_any_instance_of(test)
        .to receive(:scratch_encounter_resources).and_return(
          {
            all: [encounter_no_extension, encounter]
          }
        )
    end

    it 'passes when both a patient and encounter resource have interpreter required extension' do
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'passes when only one encounter resource has interpreter required extension' do
      patient.extension = nil
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'passes when only one patient resource has interpreter required extension' do
      encounter.extension = nil
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'fails if the interpreter required extension is not found any patient or encounter resources' do
      encounter.extension = nil
      patient.extension = nil
      result = run(test)
      expect(result.result).to eq('fail')
      expect(result.result_message).to match(
        'A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one'
      )
    end

    it 'fails if the interpreter required extension is not found on any patient and no encounter resources are found' do
      allow_any_instance_of(test)
        .to receive(:scratch_encounter_resources).and_return({})

      patient.extension = nil

      result = run(test)
      expect(result.result).to eq('fail')
      expect(result.result_message).to match(
        'A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one'
      )
    end
  end
end
