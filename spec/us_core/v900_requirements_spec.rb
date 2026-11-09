RSpec.describe 'US Core v9 requirement corrections' do
  def build_test(group, suffix, resources: [], inputs: {})
    suite = Inferno::Repositories::TestSuites.new.find('us_core_v900')
    api = suite.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_v900_fhir_api') }
    profile_group = api.groups.find { |candidate| candidate.id.to_s.end_with?("us_core_v900_#{group}") }
    test = profile_group.tests.find { |candidate| candidate.id.to_s.end_with?("us_core_v900_#{group}_#{suffix}_test") }
    raise "Test not registered: #{group} #{suffix}" unless test

    instance = test.new(scratch: {}, inputs: inputs)
    instance.scratch_resources[:all] = resources
    instance
  end

  def missing_support(instance)
    instance.missing_must_support_elements(instance.all_scratch_resources, nil, metadata: instance.metadata)
  end

  def device(**extra)
    FHIR::Device.new({ type: { text: 'Medical device' }, patient: { reference: 'Patient/p1' } }.merge(extra))
  end

  def family_history(**extra)
    FHIR::FamilyMemberHistory.new({
      id: 'f1', status: 'completed', patient: { reference: 'Patient/p1' },
      relationship: { text: 'Mother' }, condition: [{ code: { text: 'Diabetes' } }]
    }.merge(extra))
  end

  def stub_collection(instance, resources, &selector)
    allow(instance).to receive(:fhir_search) { |_type, params:, **_args| @collection_params = params }
    allow(instance).to receive(:response).and_return({ status: 200 })
    allow(instance).to receive(:check_search_response)
    allow(instance).to receive(:fetch_and_assert_all_bundled_resources) do |**_args|
      selector.nil? || selector.call(@collection_params) ? resources : []
    end
    allow(instance).to receive(:all_search_variants_tested?).and_return(true)
  end

  it 'checks Additional USCDI Device fields without separately demanding absent carrier children' do
    test = build_test('device', 'must_support', resources: [device])
    missing = missing_support(test)
    expect(missing).to include('udiCarrier', 'distinctIdentifier', 'manufactureDate',
                              'expirationDate', 'lotNumber', 'serialNumber')
    expect(missing).not_to include('udiCarrier.deviceIdentifier', 'udiCarrier.carrierHRF')
  end

  it 'checks carrierHRF when a UDI carrier is provided' do
    test = build_test('device', 'must_support', resources: [device(udiCarrier: [{ deviceIdentifier: '123' }])])
    expect(missing_support(test)).to include('udiCarrier.carrierHRF')
  end

  it 'accepts supported UDI data without requiring AIDC, entryType or jurisdiction' do
    data = device(
      udiCarrier: [{ deviceIdentifier: '123', carrierHRF: '(01)123' }], distinctIdentifier: 'di',
      manufactureDate: '2020-01-01', expirationDate: '2030-01-01', lotNumber: 'lot', serialNumber: 'serial'
    )
    test = build_test('device', 'must_support', resources: [data])
    expect(missing_support(test)).to be_empty
  end

  it 'checks deviceIdentifier when a UDI carrier is provided' do
    test = build_test('device', 'must_support', resources: [device(udiCarrier: [{ carrierHRF: '(01)123' }])])
    expect(missing_support(test)).to include('udiCarrier.deviceIdentifier')
  end

  it 'does not mutate class metadata while checking conditional Device children' do
    test = build_test('device', 'must_support', resources: [device])
    original = Marshal.dump(test.class.metadata.to_hash)
    missing_support(test)
    expect(Marshal.dump(test.class.metadata.to_hash)).to eq(original)
  end

  %w[blood_pressure average_blood_pressure].each do |group|
    it "checks all three absence-reason paths for #{group}" do
      systolic, diastolic = group == 'blood_pressure' ? ['8480-6', '8462-4'] : ['96608-5', '96609-3']
      with_values = FHIR::Observation.new(
        component: [systolic, diastolic].map do |code|
          { code: { coding: [{ system: 'http://loinc.org', code: code }] }, valueQuantity: { value: 100 } }
        end
      )
      with_reasons = FHIR::Observation.new(
        component: [systolic, diastolic].map do |code|
          { code: { coding: [{ system: 'http://loinc.org', code: code }] },
            dataAbsentReason: { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/data-absent-reason',
                                          code: 'unknown' }] } }
        end
      )
      paths = %w[component.dataAbsentReason component:systolic.dataAbsentReason component:diastolic.dataAbsentReason]
      without = build_test(group, 'must_support', resources: [with_values])
      expect(missing_support(without)).to include(*paths)
      with = build_test(group, 'must_support', resources: [with_values, with_reasons])
      expect(missing_support(with) & paths).to be_empty
    end
  end

  it 'does not require removed ADI authentication time or optional attester' do
    test = build_test('adi_document_reference', 'must_support')
    expect(test.metadata.must_supports[:extensions]).to be_empty
  end

  it 'accepts the new sex canonical for Additional USCDI support' do
    patient = FHIR::Patient.new(extension: [{
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-individual-sex', valueCoding: { code: '248152002' }
    }])
    test = build_test('patient', 'must_support', resources: [patient])
    expect(missing_support(test)).not_to include('extension:sex')
  end

  it 'does not let the old sex canonical satisfy v9 Additional USCDI support' do
    patient = FHIR::Patient.new(extension: [{
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex', valueCoding: { code: '248152002' }
    }])
    test = build_test('patient', 'must_support', resources: [patient])
    expect(missing_support(test)).to include('extension:sex')
  end

  it 'matches the v9 THO transmitter slice and rejects the old-system substitute' do
    make = lambda do |system|
      FHIR::Provenance.new(agent: [{ type: { coding: [{ system: system, code: 'transmitter' }] },
                                   who: { reference: 'Organization/o1' } }])
    end
    current = build_test('provenance', 'must_support', resources: [make.call('http://terminology.hl7.org/CodeSystem/provenance-participant-type')])
    legacy = build_test('provenance', 'must_support', resources: [make.call('http://hl7.org/fhir/us/core/CodeSystem/us-core-provenance-participant-type')])
    expect(missing_support(current)).not_to include('agent:ProvenanceTransmitter')
    expect(missing_support(legacy)).to include('agent:ProvenanceTransmitter')
  end

  it 'reads FamilyMemberHistory collected by patient even without delayed references' do
    test = build_test('family_member_history', 'read', resources: [family_history])
    expect(test).to receive(:read_and_validate).with(have_attributes(id: 'f1'))
    test.instance_eval(&test.block)
  end

  it 'checks family-history condition codes and the Additional USCDI recorder' do
    test = build_test('family_member_history', 'must_support', resources: [family_history])
    expect(missing_support(test)).to include('extension:recorder')

    recorder = [{
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory-recorder',
      valueReference: { reference: 'Practitioner/p2' }
    }]
    complete = build_test('family_member_history', 'must_support', resources: [family_history(extension: recorder)])
    expect(missing_support(complete)).to be_empty

    without_code = family_history(extension: recorder, condition: [{ onsetString: 'Childhood' }])
    missing = build_test('family_member_history', 'must_support', resources: [without_code])
    expect(missing_support(missing)).to include('condition.code')
  end

  it 'keeps FamilyMemberHistory patient+code search optional and derives a condition code' do
    resource = family_history(condition: [{ code: { coding: [{ system: 'http://snomed.info/sct', code: '73211009' }] } }])
    test = build_test('family_member_history', 'patient_code_search', inputs: { patient_ids: 'p1' })
    test.scratch_resources['p1'] = [resource]
    expect(test.class.optional?).to be(true)
    expect(test.all_search_params['p1']).to include({ 'patient' => 'p1', 'code' => '73211009' })
  end

  it 'collects a non-assess-plan CarePlan using the supplied category' do
    plan = FHIR::CarePlan.new(id: 'c1', subject: { reference: 'Patient/p1' },
                             category: [{ coding: [{ code: 'longitudinal' }] }])
    test = build_test('care_plan', 'patient_category_search',
                      inputs: { patient_ids: 'p1', care_plan_categories: 'longitudinal' })
    stub_collection(test, [plan])
    test.instance_eval(&test.block)
    expect(@collection_params).to eq({ 'patient' => 'p1', 'category' => 'longitudinal' })
    expect(test.all_scratch_resources).to include(plan)
  end

  it 'collects the new electronic-cigarette observation using its code' do
    observation = FHIR::Observation.new(id: 'e1', subject: { reference: 'Patient/p1' },
                                       code: { coding: [{ system: 'http://loinc.org', code: '105045-9' }] })
    test = build_test('smokingstatus', 'patient_code_search', inputs: { patient_ids: 'p1' })
    stub_collection(test, [observation]) { |params| params['code'] == '105045-9' }
    test.instance_eval(&test.block)
    expect(test.all_scratch_resources).to include(observation)
  end

  it 'resolves present CarePlan.addresses against the v9 Condition profile' do
    plan = FHIR::CarePlan.new(subject: { reference: 'Patient/p1' }, addresses: [{ reference: 'Condition/c1' }])
    test = build_test('care_plan', 'reference_resolution', resources: [plan])
    calls = []
    allow(test).to receive(:validate_reference_resolution) do |_resource, reference, profile|
      calls << [reference.reference, profile]
      true
    end
    expect(test.unresolved_references([plan])).to be_empty
    expect(calls).to include(['Condition/c1', 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns'])
  end

  it 'finds the family recorder reference and accepts one allowed target alternative' do
    data = family_history(extension: [{
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory-recorder',
      valueReference: { reference: 'Practitioner/p2' }
    }])
    test = build_test('family_member_history', 'reference_resolution', resources: [data])
    calls = []
    allow(test).to receive(:validate_reference_resolution) do |_resource, reference, profile|
      calls << reference.reference
      reference.reference == 'Patient/p1' || profile.end_with?('us-core-practitioner')
    end
    expect(test.unresolved_references([data])).to be_empty
    expect(calls).to include('Practitioner/p2')
  end

  it 'preserves existing support checks outside Device and FamilyMemberHistory' do
    patient = build_test('patient', 'must_support', resources: [FHIR::Patient.new])
    expect(missing_support(patient)).to include('extension:sex')
  end

  it 'validates v9 reference targets against v9 without changing base FHIR targets' do
    test = build_test('care_plan', 'reference_resolution')
    resource = FHIR::Patient.new(id: 'p1')
    targets = {
      'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient' =>
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|9.0.0',
      'http://hl7.org/fhir/StructureDefinition/Patient' =>
        'http://hl7.org/fhir/StructureDefinition/Patient'
    }
    targets.each do |target, expected|
      expect(test).to receive(:resource_is_valid?)
        .with(resource: resource, profile_url: expected, add_messages_to_runnable: false).and_return(true)
      expect(test.resource_is_valid_with_target_profile?(resource, target)).to be(true)
    end
  end

  it 'does not demand an absent family recorder reference' do
    data = family_history
    test = build_test('family_member_history', 'reference_resolution', resources: [data])
    expect(test).to receive(:validate_reference_resolution).with(data, anything, anything).and_return(true)
    expect(test.unresolved_references([data])).to be_empty
  end

  it 'advertises the renamed Device and new FamilyMemberHistory profile in the v9 catalog' do
    profiles = USCoreTestKit::USCoreV900::CapabilityStatementGroup::PROFILES
    expect(profiles['Device']).to eq(['http://hl7.org/fhir/us/core/StructureDefinition/us-core-device'])
    expect(profiles['FamilyMemberHistory']).to eq(['http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory'])
  end

  it 'keeps a dated ADI category when adding the token system to a mixed DocumentReference search' do
    bundle = JSON.parse(File.read('lib/us_core_test_kit/client/fixtures/v9.0.0/bundle.json'))
    documents = bundle['entry'].map { |entry| entry['resource'] }
                        .select { |resource| resource['resourceType'] == 'DocumentReference' }
                        .map { |resource| FHIR.from_contents(resource.to_json) }
    test = build_test('document_reference', 'patient_category_date_search',
                      inputs: { patient_ids: 'us-core-client-tests-patient' })
    test.scratch_resources['us-core-client-tests-patient'] = documents

    expect(test.all_search_params['us-core-client-tests-patient'].first).to include(
      'category' => '42348-3', 'date' => documents.last.date
    )
    expect(test.search_params_with_values(['category'], 'us-core-client-tests-patient', include_system: true))
      .to eq('category' => 'http://loinc.org|42348-3')
  end

  it 'does not register a clinical-note write attestation' do
    suite = Inferno::Repositories::TestSuites.new.find('us_core_v900')
    api = suite.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_v900_fhir_api') }
    notes = api.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_v900_clinical_notes_guidance') }
    expect(notes.tests.map(&:id).join).not_to include('write_workflow')
    expect(notes.tests.length).to eq(2)
  end
end
