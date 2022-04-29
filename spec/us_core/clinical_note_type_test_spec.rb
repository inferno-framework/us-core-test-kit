require_relative '../../lib/us_core_test_kit/custom_groups/clinical_note_type_test'

RSpec.describe USCoreTestKit::ClinicalNoteTypeTest do
  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { '85' }
  #let(:clinical_note_type_test) { Inferno::Repositories::Tests.new.find('us_core_clinical_note_types') }
  let(:runnable) { USCoreTestKit::USCoreV311::USCoreTestSuite.groups
     .find { |group| group.id.include? 'clinical_notes_guidance'}
     .tests.find { |test| test.id.include? 'clinical_note_types' }.new }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'us_core_v311') }
  #let(:tester) {USCoreTestKit::ClinicalNoteTypeTest.new}

  # let(:diagnostic_report_id) { '200' }
  # let(:test_scratch) { {} }

  # def run(runnable, inputs = {})
  #   test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
  #   test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
  #   inputs.each do |name, value|
  #     session_data_repo.save(
  #       test_session_id: test_session.id,
  #       name: name,
  #       value: value,
  #       type: runnable.config.input_type(name)
  #     )
  #   end
  #   Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  # end

  describe '#diagnostic_report_categories_found' do
    it 'returns category codes' do
      #result = run(runnable, {patient_ids: patient_id})
      result = runnable.diagnostic_report_categories_found(patient_id)
      require 'pry'; require 'pry-byebug'; binding.pry
      expect(result.result).to eq('pass')
    end
  end

  # before do
  #   allow_any_instance_of(clinical_note_type_test)
  #     .to receive(:scratch).and_return(test_scratch)
  # end

  # it 'passes when all required types are found' do
  #   result = run(clinical_note_type_test, patient_ids: patient_id)
  #   require 'pry'; require 'pry-byebug'; binding.pry
  #   expect(result.result).to eq('pass')
  # end
end