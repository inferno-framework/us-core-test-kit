require_relative '../../lib/us_core_test_kit/custom_groups/screening_assessment_category_test'

RSpec.describe USCoreTestKit::ScreeningAssessmentCategoryTest do
  let(:suite_id) { 'us_core_v610' }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { '85' }
  let(:observation_categories) do
    [
      {
        system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
        code: 'sdoh'
      },
      {
        system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
        code: 'functional-status'
      },
      {
        system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
        code: 'disability-status'
      },
      {
        system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
        code: 'cognitive-status'
      }
    ]
  end
  let(:condition_categories) do
    [
      {
        system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
        code: 'sdoh'
      }
    ]
  end

  let(:test_class) do
    obs_categories = observation_categories
    cond_categories = condition_categories
    Class.new(USCoreTestKit::ScreeningAssessmentCategoryTest) do
      fhir_client { url 'http://example.com/fhir' }
      config(
        options:
        {
          condition_screening_assessment_categories: cond_categories,
          observation_screening_assessment_categories: obs_categories
        }
      )
    end
  end

  let(:test_scratch) { {} }

  let(:observation_sdoh) do
    FHIR::Observation.new(
      id: 'sdoh',
      category: [
        { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'survey' }] },
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category', code: 'sdoh' }] }
      ]
    )
  end
  let(:observation_functional_status) do
    FHIR::Observation.new(
      id: 'functional-status',
      category: [
        { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'survey' }] },
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category', code: 'functional-status' }] }
      ]
    )
  end
  let(:observation_diability_status) do
    FHIR::Observation.new(
      id: 'disability-status',
      category: [
        { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'survey' }] },
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category', code: 'disability-status' }] }
      ]
    )
  end
  let(:observation_cognitive_status) do
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'survey' }] },
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category', code: 'cognitive-status' }] }
      ]
    )
  end
  let(:observation_survey) do
    FHIR::Observation.new(
      id: 'cognitive-status',
      category: [
        { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'survey' }] }
      ]
    )
  end
  let(:condition_sdoh) do
    FHIR::Condition.new(
      id: 'sdoh',
      category: [
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/condition-category', code: 'health-concern' }] },
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category', code: 'sdoh' }] }
      ]
    )
  end
  let(:condition_non_sdoh) do
    FHIR::Condition.new(
      id: 'non_sdoh',
      category: [
        { coding: [{ system: 'http://hl7.org/fhir/us/core/CodeSystem/condition-category', code: 'health-concern' }] }
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
        { resource: condition_sdoh },
        { resource: condition_non_sdoh }
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
      expect(result.result_message).to include('Observation categories: http://hl7.org/fhir/us/core/CodeSystem/us-core-category|functional-status')
    end

    it 'skips when a Condition category is missing' do
      condition_bundle.entry.delete_at(0)

      stub_request(:get, "#{url}/Condition?patient=85&category=health-concern")
        .to_return(status: 200, body: condition_bundle.to_json)

      result = run(test_class, patient_ids: patient_id)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Condition categories: http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh')
    end

    it 'skips when Observation and Condition categories are missing' do
      observation_bundle.entry.delete_at(1)
      observation_bundle.entry.delete_at(1)
      condition_bundle.entry.delete_at(0)

      stub_request(:get, "#{url}/Observation?patient=85&category=survey")
        .to_return(status: 200, body: observation_bundle.to_json)
      stub_request(:get, "#{url}/Condition?patient=85&category=health-concern")
        .to_return(status: 200, body: condition_bundle.to_json)

      result = run(test_class, patient_ids: patient_id)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Observation categories')
      expect(result.result_message).to include('functional-status')
      expect(result.result_message).to include('disability-status')
      expect(result.result_message).to include('Condition categories')
      expect(result.result_message).to include('sdoh')
    end
  end
end
