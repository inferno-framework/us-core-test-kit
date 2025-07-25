require_relative '../../lib/us_core_test_kit/custom_groups/v3.1.1/resource_support_test'

RSpec.describe USCoreTestKit::USCoreV311::ProfileSupportTest do
  let(:suite_id) { 'us_core_v311' }
  # we can't use `described_class` directly because it omits parent inputs
  let(:test) { find_test suite, described_class.id }
  let(:url) { 'http://example.com/fhir' }

  context 'with no required resources' do
    before do
      allow_any_instance_of(test).to receive(:config).and_return(
                                       OpenStruct.new(
                                         options: {
                                           us_core_resources: ['Patient', 'Condition', 'Observation']
                                         }
                                       )
                                     )
    end

    it 'fails if Patient is not supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'Condition'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('US Core Patient profile not supported')
    end

    it 'fails if only the Patient resource is supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'Patient'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('No US Core resources other than Patient are supported')
    end

    it 'passes if Patient and one other resource are supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'Patient'
                },
                {
                  type: 'Observation'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('pass')
    end
  end

  context 'with required resources' do
    before do
      allow_any_instance_of(test).to receive(:config).and_return(
                                       OpenStruct.new(
                                         options: {
                                           us_core_resources: ['Patient', 'Condition', 'Observation'],
                                           required_resources: ['Patient', 'Condition', 'Observation']
                                         }
                                       )
                                     )
    end

    it 'fails if not all required resources are supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'Patient'
                },
                {
                  type: 'Observation'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('fail')
      expect(result.result_message).to include('Condition')
    end

    it 'passes if not required resources are supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'Patient'
                },
                {
                  type: 'Observation'
                },
                {
                  type: 'Condition'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('pass')
    end
  end
end
