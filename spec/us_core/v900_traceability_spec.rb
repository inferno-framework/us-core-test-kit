require 'csv'

RSpec.describe 'US Core v9 requirement traceability' do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v900') }
  let(:runnables) { [suite] + suite.all_descendants }
  let(:requirements) { Inferno::Repositories::Requirements.new }
  let(:catalog) do
    CSV.read('lib/us_core_test_kit/requirements/us_core_v900_requirements.csv', headers: true)
  end

  it 'loads each cited v9 requirement with a v9 source and the server actor' do
    ids = runnables.flat_map(&:verifies_requirements).grep(/^hl7\.fhir\.us\.core_/).uniq
    expect(ids).not_to be_empty
    expect(ids).to all(start_with('hl7.fhir.us.core_9.0.0@'))
    ids.each do |id|
      requirement = requirements.find(id)
      expect(requirement).not_to be_nil, "Unresolved requirement #{id}"
      expect(requirement.url).to start_with('https://hl7.org/fhir/us/core/STU9/')
      expect(requirement.actors).to include('Server')
    end
  end

  it 'keeps published narrative keys distinct from local structured-capability IDs' do
    published, local = catalog.partition { |row| row['Source Kind'] == 'Published narrative requirement' }
    expect(published.length).to eq(555)
    expect(local.map { |row| row['ID'] }).to match_array(%w[1001 1002 1003 1004 1005 1006])
    expect(catalog.map { |row| row['ID'] }.uniq.length).to eq(catalog.length)
    expect(catalog.map { |row| row['Conformance'] }).not_to include('DEPRECATED')
    expect(published).to all(satisfy { |row| row['Source Key'] == format('CONF-%04d', row['ID'].to_i) })
  end

  it 'does not leave dangling local subrequirements or old-version cross-links' do
    ids = catalog.map { |row| "hl7.fhir.us.core_9.0.0@#{row['ID']}" }
    ids.each do |id|
      requirement = requirements.find(id)
      expect(requirement).not_to be_nil
      requirement.subrequirements.grep(/^hl7\.fhir\.us\.core_/).each do |child|
        expect(ids).to include(child), "Unresolved subrequirement #{child} in #{id}"
      end
    end
  end

  it 'labels FamilyMemberHistory read and searches with the correct capability strength' do
    mappings = { 'read' => '1004', 'patient_search' => '1005', 'patient_code_search' => '1006' }
    mappings.each do |suffix, id|
      test = runnables.find { |r| r.id.to_s.end_with?("us_core_v900_family_member_history_#{suffix}_test") }
      expect(test.verifies_requirements).to include("hl7.fhir.us.core_9.0.0@#{id}")
    end
    expect(requirements.find('hl7.fhir.us.core_9.0.0@1006').conformance).to eq('SHOULD')
    recommended = runnables.find { |r| r.id.to_s.end_with?('family_member_history_patient_code_search_test') }
    expect(recommended.optional?).to be(true)
  end

  it 'relabels shared discovery copies without mutating older suites or claiming user approval checks' do
    copies = runnables.select { |r| r.id.to_s.end_with?('-us_core_smart_well_known_capabilities') }
    expect(copies.length).to eq(4)
    copies.each do |test|
      expect(test.verifies_requirements).to eq(%w[hl7.fhir.us.core_9.0.0@167 hl7.fhir.us.core_9.0.0@173])
    end
    older = Inferno::Repositories::TestSuites.new.find('us_core_v800').all_descendants
                  .select { |r| r.id.to_s.end_with?('-us_core_smart_well_known_capabilities') }
    expect(older).not_to be_empty
    older.each do |test|
      expect(test.verifies_requirements).to include('hl7.fhir.us.core_8.0.0@171')
      expect(test.verifies_requirements).not_to include('hl7.fhir.us.core_9.0.0@167')
    end
  end
end
