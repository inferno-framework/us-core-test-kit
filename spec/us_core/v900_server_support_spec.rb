RSpec.describe 'US Core v9 supporting coverage', :runnable do
  let(:suite_id) { 'us_core_v900' }
  let(:api) { suite.groups.find { |group| group.id.to_s.end_with?('us_core_v900_fhir_api') } }

  def descendants(group)
    [group] + (group.respond_to?(:children) ? group.children.flat_map { |child| descendants(child) } : [])
  end

  def provenance(who, on_behalf_of: nil, contained: [])
    FHIR::Provenance.new(id: 'p1', agent: [{ who: { reference: who }, onBehalfOf: on_behalf_of }], contained: contained)
  end

  it 'registers missing-data and screening coverage inside the v9 API group' do
    expect(api.groups.map { |group| group.id.to_s.split('-').last }).to include(
      'us_core_311_data_absent_reason', 'us_core_v800_screening_assessment'
    )
  end

  it 'connects both SMART versions to the v9 granular scope sets' do
    groups = suite.groups.select { |group| group.id.to_s.include?('smart_granular_scopes') }
    expect(groups.length).to eq(2)
    groups.each do |group|
      group.groups.each_with_index do |scope_group, index|
        expected = USCoreTestKit::USCoreV900SmartScopesConstants.const_get("SMART_GRANULAR_SCOPES_GROUP#{index + 1}")['v900']
        expect(scope_group.config.options[:required_scopes]).to eq(expected)
        credentials = scope_group.config.inputs[:smart_auth_info]
        scopes = credentials.options[:components].find { |component| component[:name] == :requested_scopes }[:default]
        expect(scopes.split(' ')).to include(*expected)
      end
    end
  end

  it 'uses the validation outputs to distinguish missing-data evidence from its absence' do
    group = api.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_311_data_absent_reason') }
    group.tests.each do |test|
      key = test.id.to_s.end_with?('_extension') ? :dar_extension_found : :dar_code_found
      present = test.new(inputs: { key => 'true' })
      missing = test.new(inputs: { key => 'false' })
      expect { present.instance_eval(&test.block) }.not_to raise_error
      expect { missing.instance_eval(&test.block) }.to raise_error(Inferno::Exceptions::AssertionException)
    end
  end

  it 'executes the registered screening check against all configured categories' do
    group = api.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_v800_screening_assessment') }
    test = group.tests.first.new(inputs: { patient_ids: 'p1' })
    current_type = nil
    allow(test).to receive(:search_and_check_response) { |_params, type| current_type = type }
    allow(test).to receive(:fetch_all_bundled_resources) do |**_args|
      key = current_type == 'Condition' ? :condition_screening_assessment_categories : :observation_screening_assessment_categories
      categories = test.config.options[key].map { |coding| { coding: [coding] } }
      [FHIR.const_get(current_type).new(category: categories)]
    end
    expect { test.instance_eval(&test.class.block) }.to raise_error(Inferno::Exceptions::PassException)
  end

  [false, true].each do |leak|
    it "#{leak ? 'rejects' : 'accepts'} replay results #{leak ? 'outside' : 'inside'} granted granular scopes" do
      group = suite.groups.find { |candidate| candidate.id.to_s.end_with?('us_core_v900_smart_granular_scopes') }
      test_class = descendants(group).find { |candidate| candidate.id.to_s.end_with?('Observation_patient_category_granular_scope_search_test') }
      scope = 'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory'
      test = test_class.new(inputs: { received_scopes: scope, url: 'http://example.com/fhir', patient_ids: 'p1' })
      make = ->(id, category) { FHIR::Observation.new(id: id, category: [{ coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: category }] }]) }
      inside = make.call('inside', 'laboratory')
      outside = make.call('outside', 'vital-signs')
      original = Struct.new(:verb, :query_parameters).new('get', { 'patient' => 'p1', 'category' => 'laboratory' })
      test.previous_requests = [original]
      allow(test).to receive(:load_previous_requests)
      allow(test).to receive(:previous_request_resources).and_return({ original => [inside, outside] })
      allow(test).to receive(:fhir_search)
      allow(test).to receive(:request).and_return(Struct.new(:status).new(200))
      allow(test).to receive(:resource).and_return(FHIR::Bundle.new)
      allow(test).to receive(:fetch_all_bundled_resources).and_return(leak ? [inside, outside] : [inside])
      if leak
        expect { test.run_scope_search_test }.to raise_error(Inferno::Exceptions::AssertionException, /do not match/)
      else
        expect { test.run_scope_search_test }.not_to raise_error
      end
    end
  end

  %w[Practitioner Device].each do |type|
    it "enforces provenance-1 for #{type} after filtering the invalid FHIRPath expression" do
      validator = suite.find_validator(:default)
      outcome = { outcomes: [{ issues: [{ location: 'Provenance.agent[0]', message: 'Constraint failed: provenance-1', level: 'ERROR' }] }] }
      stub_request(:post, validation_url).to_return(status: 200, body: outcome.to_json)
      runnable = Inferno::Entities::Test.new
      expect(validator.resource_is_valid?(provenance("#{type}/one"), 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance|9.0.0', runnable)).to be(false)
      expect(USCoreTestKit::USCoreV900::ProvenanceValidator.validate(provenance("#{type}/one", on_behalf_of: { reference: 'Organization/o1' }))).to be_empty
    end
  end

  %w[PractitionerRole/r1 Organization/Practitioner-services].each do |reference|
    it "does not impose the Practitioner/Device rule on #{reference}" do
      expect(USCoreTestKit::USCoreV900::ProvenanceValidator.validate(provenance(reference))).to be_empty
    end
  end

  it 'enforces provenance-1 for a contained Practitioner' do
    data = provenance('#person', contained: [FHIR::Practitioner.new(id: 'person')])
    expect(USCoreTestKit::USCoreV900::ProvenanceValidator.validate(data)).not_to be_empty
  end

  [
    "Patient.extension[0].url: URL value 'http://example.org/extension' does not resolve",
    "Patient.extension[0].url: No definition could be found for URL value 'http://example.org/extension'",
    "Observation.effective.ofType(Period): Constraint failed: us-core-1:",
    "Condition.code: The code provided was not found in the value set 'US Core Condition Codes'",
    "DocumentReference.content.format: A definition for CodeSystem 'http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem' could not be found, so the code cannot be validated"
  ].each do |message|
    it "does not suppress the validation error: #{message}" do
      validator = suite.find_validator(:default)
      outcome = { outcomes: [{ issues: [{ location: 'Patient', message: message, level: 'ERROR' }] }] }
      stub_request(:post, validation_url).to_return(status: 200, body: outcome.to_json)
      runnable = Inferno::Entities::Test.new
      expect(validator.resource_is_valid?(FHIR::Patient.new(id: 'p1'), 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|9.0.0', runnable)).to be(false)
    end
  end
end
