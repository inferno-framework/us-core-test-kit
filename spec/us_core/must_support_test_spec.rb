RSpec.describe USCoreTestKit::MustSupportTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:patient_ref) { 'Patient/85' }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name: name,
        value: value,
        type: runnable.config.input_type(name)
      )
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'must support test for choice elements and regular elements' do
    let(:device_must_support_test) { Inferno::Repositories::Tests.new.find('us_core_v311_device_must_support_test')}
    let(:device) do
      FHIR::Device.new(
        udiCarrier: [{ deviceIdentifier: '43069338026389', carrierHRF: 'carrierHRF' }],
        distinctIdentifier: '43069338026389',
        manufactureDate: '2000-03-02T18:33:18-05:00',
        expirationDate: '2025-03-17T19:33:18-04:00',
        lotNumber: '1134',
        serialNumber: '842026117977',
        type: {
          text: 'Implantable defibrillator, device (physical object)'
        },
        patient: {
          reference: patient_ref
        }
      )
    end

    it 'fails if server supports none of the choice' do
      device.udiCarrier.first.carrierHRF = nil
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('udiCarrier.carrierAIDC, udiCarrier.carrierHRF')
    end

    it 'passes if server supports at least one of the choice' do
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('pass')
    end

    it 'fails if server does not support one MS element' do
      device.distinctIdentifier = nil
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('distinctIdentifier')
    end
  end

  describe 'must support test for extensions' do
    let(:patient_must_support_test) { Inferno::Repositories::Tests.new.find('us_core_v311_patient_must_support_test')}
    let(:patient) do
      FHIR::Patient.new(
        identifier: [{system: 'system', value: 'value'}],
        name: [{family: 'family', given: 'given'}],
        telecom: [{system: 'phone', value: 'value', use: 'home'}],
        gender: 'male',
        birthDate: '2020-01-01',
        address: [{line: 'line', city: 'city', state: 'state', postalCode: 'postalCode', period: {start: '2020-01-01'}}],
        communication: [{language: {text: 'text'}}],
        extension: [
          {
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
            extension: [
              {url: 'ombCategory', valueCoding: {display: 'display'}},
              {url: 'text', valueString: 'valueString'}
            ]
          },
          {
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity',
            extension: [
              {url: 'ombCategory', valueCoding: {display: 'display'}},
              {url: 'text', valueString: 'valueString'}
            ]
          },
          {
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex',
            valueCode: 'M'
          }
        ]
      )
    end

    it 'passes if server suports all MS extensions' do
      allow_any_instance_of(patient_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(patient_must_support_test)

      expect(result.result).to eq('pass')
    end

    it 'fails if server does not suport one MS extensions' do
      patient.extension.delete_at(0)

      allow_any_instance_of(patient_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(patient_must_support_test)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Patient.extension:race')
    end
  end

  describe 'must support test for slices' do
    let(:care_plan_must_support_test) { Inferno::Repositories::Tests.new.find('us_core_v311_care_plan_must_support_test')}
    let(:careplan) do
      FHIR::CarePlan.new(
        text: { status: 'status' },
        status: 'status',
        intent: 'intent',
        category: [
          {
            coding: [
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/careplan-category',
                code: 'assess-plan'
              }
            ]
          }
        ],
        subject: {
          reference: patient_ref
        }
      )
    end

    it 'passes if server suports all MS slices' do
      allow_any_instance_of(care_plan_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [careplan]
          }
        )


      result = run(care_plan_must_support_test)

      expect(result.result).to eq('pass')
    end

    it 'fails if server does not suport one MS extensions' do
      careplan.category.first.coding.first.code = 'something else'
      allow_any_instance_of(care_plan_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [careplan]
          }
        )

      result = run(care_plan_must_support_test)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('CarePlan.category:AssessPlan')
    end
  end
end
