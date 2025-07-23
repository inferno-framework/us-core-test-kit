require_relative '../../lib/us_core_test_kit/custom_groups/capability_statement/profile_support_test'

RSpec.describe USCoreTestKit::InstantiateTest do
  let(:suite_id) { 'us_core_v400' }
  # we can't use `described_class` directly because it omits parent inputs
  let(:test) { find_test suite, described_class.id }
  let(:url) { 'http://example.com/fhir' }

  it 'passes if instantiates does not have version' do
    response_body =
      FHIR::CapabilityStatement.new(
        instantiates: [
          'http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server'
        ]
      ).to_json
    repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

    result = run(test, url:)

    expect(result.result).to eq('pass')
  end

  it 'passes if instantiates has version' do
    response_body =
      FHIR::CapabilityStatement.new(
        instantiates: [
          'http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|6.1.0'
        ]
      ).to_json
    repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

    result = run(test, url:)

    expect(result.result).to eq('pass')
  end
end
