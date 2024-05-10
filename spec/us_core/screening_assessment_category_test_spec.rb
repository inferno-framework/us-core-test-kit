require_relative '../../lib/us_core_test_kit/custom_groups/screening_assessment_category_test'

RSpec.describe USCoreTestKit::ScreeningAssessmentCategoryTest do
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

  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v610') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }

  #let(:test_class) { USCoreTestKit::ScreeningAssessmentCategoryTest }

  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { '85' }

  let(:test_class) do
    Class.new(USCoreTestKit::ScreeningAssessmentCategoryTest) do
      fhir_client { url :url }
      input :url, :patient_ids
    end
  end

  let(:test_scratch) { {} }

  let(:observation_sdoh) {
    FHIR::Observation.new(
      id: 'sdoh',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'sdoh'}]}
      ]
    )
  }
  let(:observation_functional_status) {
    FHIR::Observation.new(
      id: 'functional-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'functional-status'}]}
      ]
    )
  }
  let(:observation_diability_status) {
    FHIR::Observation.new(
      id: 'diability-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'diability-status'}]}
      ]
    )
  }
  let(:observation_cognitive_status) {
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'cognitive-status'}]}
      ]
    )
  }
  let(:observation_survey) {
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ code: 'survey' }] }
      ]
    )
  }
  let(:condition_sdoh) {
    FHIR::Condition.new(
      id: 'sdoh',
      category: [
        { coding: [{ code: 'health-concern' }] },
        { coding: [{ code: 'sdoh'}]}
      ]
    )
  }
  let(:observation_bundle) {
    FHIR::Bundle.new(
      entry: [
        { resource: observation_sdoh},
        { resource: observation_functional_status},
        { resource: observation_diability_status},
        { resource: observation_cognitive_status},
        { resource: observation_survey}
      ]
    )
  }
  let(:condition_bundle) {
    FHIR::Bundle.new(
      entry: [
        { resource: condition_sdoh}
      ]
    )
  }

  describe 'Screening Assessments Category Test' do
    before do
      stub_request(:get, "#{url}/Observation?patient=85&category=survey")
        .to_return(status: 200, body: observation_bundle.to_json)

      stub_request(:get, "#{url}/Condition?patient=85&category=health-concern")
        .to_return(status: 200, body: condition_bundle.to_json)

      stub_request(:get, "#{url}/Condition?patient=85&category=problem-list")
        .to_return(status: 200, body: FHIR::Bundle.new().to_json)

      allow_any_instance_of(test_class)
        .to receive(:scratch).and_return(test_scratch)
    end

    it 'passes when all categories are returned' do
      result = run(test_class, patient_ids: patient_id)

      binding.pry
      expect(result.result).to eq('pass')
    end
  end
end