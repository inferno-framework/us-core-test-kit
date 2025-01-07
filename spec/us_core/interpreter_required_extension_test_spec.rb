# frozen_string_literal: true

require_relative '../../lib/us_core_test_kit/generated/v8.0.0/encounter/interpreter_required_extension_test'

RSpec.describe USCoreTestKit::USCoreV800::InterpreterRequiredExtensionTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v800') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
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

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name:,
        value:,
        type: runnable.config.input_type(name)
      )
    end
    Inferno::TestRunner.new(test_session:, test_run:).run(runnable)
  end

  describe 'interpreter required extension test' do
    before do
      allow_any_instance_of(test)
        .to receive(:scratch_patient_resources).and_return(
          {
            all: [patient]
          }
        )

      allow_any_instance_of(test)
        .to receive(:scratch_encounter_resources).and_return(
          {
            all: [encounter]
          }
        )
    end

    it 'passes when both patient and encounter have interpreter required extension' do
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'passes when only the encounter resource has interpreter required extension' do
      patient.extension = nil
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'passes when only the patient resource has interpreter required extension' do
      encounter.extension = nil
      result = run(test)
      expect(result.result).to eq('pass')
    end

    it 'fails if the interpreter required extension is not found on the patient or encounter resource' do
      encounter.extension = nil
      patient.extension = nil
      result = run(test)
      expect(result.result).to eq('fail')
      expect(result.result_message).to match(
        'A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one'
      )
    end

    it 'fails if the interpreter required extension is not found on patient and no encounter resource is found' do
      encounter.subject.reference = 'Patient/456'
      patient.extension = nil
      result = run(test)
      expect(result.result).to eq('fail')
      expect(result.result_message).to match(
        'Patient with id 123 did not include the US Core Interpreter Needed Extension, and no'
      )
    end
  end
end
