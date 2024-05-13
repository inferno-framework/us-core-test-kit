require_relative '../../lib/us_core_test_kit/custom_groups/screening_assessment_category_test'

RSpec.describe USCoreTestKit::ScreeningAssessmentCategoryTest do
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

  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v610') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }

  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { '85' }
  let(:observation_categories) { ['sdoh', 'functional-status', 'disability-status', 'cognitive-status'] }

  let(:test_class) do
    categories = observation_categories
    Class.new(USCoreTestKit::ScreeningAssessmentCategoryTest) do
      fhir_client { url 'http://example.com/fhir' }
      config(options: { observation_screening_assessment_categories: categories })
    end
  end

  let(:test_scratch) { {} }

  let(:observation_sdoh) do
    FHIR::Observation.new(
      id: 'sdoh',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'sdoh' }] }
      ]
    )
  end
  let(:observation_functional_status) do
    FHIR::Observation.new(
      id: 'functional-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'functional-status' }] }
      ]
    )
  end
  let(:observation_diability_status) do
    FHIR::Observation.new(
      id: 'disability-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'disability-status' }] }
      ]
    )
  end
  let(:observation_cognitive_status) do
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ code: 'survey' }] },
        { coding: [{ code: 'cognitive-status' }] }
      ]
    )
  end
  let(:observation_survey) do
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ code: 'survey' }] }
      ]
    )
  end
  let(:condition_sdoh) do
    FHIR::Condition.new(
      id: 'sdoh',
      category: [
        { coding: [{ code: 'health-concern' }] },
        { coding: [{ code: 'sdoh' }] }
      ]
    )
  end
  let(:observation_bundle) do
    FHIR::Bundle.new(
      entry: [
        { resource: observation_sdoh },
        { resource: observation_functional_status },
        { resource: observation_diability_status },
        { resource: observation_cognitive_status },
        { resource: observation_survey }
      ]
    )
  end
  let(:condition_bundle) do
    FHIR::Bundle.new(
      entry: [
        { resource: condition_sdoh }
      ]
    )
  end

  describe 'Screening Assessments Category Test' do
    before do
      stub_request(:get, "#{url}/Observation?patient=85&category=survey")
        .to_return(status: 200, body: observation_bundle.to_json)

      stub_request(:get, "#{url}/Condition?patient=85&category=health-concern")
        .to_return(status: 200, body: condition_bundle.to_json)

      stub_request(:get, "#{url}/Condition?patient=85&category=problem-list-item")
        .to_return(status: 200, body: FHIR::Bundle.new.to_json)

      allow_any_instance_of(test_class)
        .to receive(:scratch).and_return(test_scratch)
    end

    it 'passes when all categories are returned' do
      result = run(test_class, patient_ids: patient_id)
      expect(result.result).to eq('pass')
    end

    it 'skips when an Observation category is missing' do
      observation_bundle.entry.delete_at(1)

      stub_request(:get, "#{url}/Observation?patient=85&category=survey")
        .to_return(status: 200, body: observation_bundle.to_json)

      result = run(test_class, patient_ids: patient_id)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Observation categories: functional-status')
    end

    it 'skips when an Condition category is missing' do
      condition_bundle.entry.first.resource.category.delete_at(1)

      stub_request(:get, "#{url}/Condition?patient=85&category=health-concern")
        .to_return(status: 200, body: condition_bundle.to_json)

      result = run(test_class, patient_ids: patient_id)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Condition category: sdoh')
    end
  end
end
