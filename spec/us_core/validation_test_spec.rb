RSpec.describe USCoreTestKit::ValidationTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:runnable) do
    Inferno::Entities::Test.new
  end

  let(:validator) do
    suite.find_validator(:default)
  end
  let(:validator_url) { validator.url }

  let(:patient_ref) { 'Patient/85' }

  let(:operation_outcome_success) do
    {
      outcomes: [{
        issues: []
      }],
      sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
    }
  end
  let(:operation_outcome_error) do
    {
      outcomes: [{
        issues: [{
          location: 'Resource.id',
          message: 'Test dummy error',
          level: 'ERROR'
        }]
      }],
      sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
    }
  end

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

  describe 'Observation BMI dataAbsentReason Validation Filter' do
    let(:profile_url) { 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi|4.0.1' }
    let(:bmi_filtered_error_outcome) do
      {
        outcomes: [{
          issues: [{
            location: 'Resource.id',
            message: "Observation: Slice 'Observation.value[x]:valueQuantity': a matching slice is required, but not found (from http://hl7.org/fhir/StructureDefinition/bmi|4.0.1)",
            level: 'ERROR'
          }]
        }],
        sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
      }
    end

    let(:observation) do
      FHIR::Observation.new(
        status: 'final',
        category: [
          {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/observation-category',
                code: 'vital-signs'
              }
            ]
          }
        ],
        code: {
          coding: [
            {
              system: 'http://loinc.org',
              code: '39156-5',
              display: 'Body mass index (BMI) [Ratio]'
            }
          ],
          text: 'Body mass index (BMI) [Ratio]'
        },
        subject: {
          reference: patient_ref
        }
      )
    end

    it 'passes with successful validation' do
      verification_request = stub_request(:post, "#{validator_url}/validate")
        .to_return(status: 200, body: operation_outcome_success.to_json)

      expect(validator.resource_is_valid?(observation, profile_url, runnable)).to be(true)
      expect(verification_request).to have_been_made
    end

    it 'passes with filtered dataAbsentReason validation error' do
      verification_request = stub_request(:post, "#{validator_url}/validate")
        .to_return(status: 200, body: bmi_filtered_error_outcome.to_json)

      expect(validator.resource_is_valid?(observation, profile_url, runnable)).to be(true)
      expect(verification_request).to have_been_made
    end

    it 'fails with non-filtered validation error' do
      verification_request = stub_request(:post, "#{validator_url}/validate")
        .to_return(status: 200, body: operation_outcome_error.to_json)
      expect(validator.resource_is_valid?(observation, profile_url, runnable)).to be(false)
      expect(verification_request).to have_been_made
    end
  end
end
