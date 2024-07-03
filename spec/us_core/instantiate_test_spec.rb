require_relative '../../lib/us_core_test_kit/custom_groups/capability_statement/profile_support_test'

RSpec.describe USCoreTestKit::InstantiateTest do
  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name:,
        value:,
        type: runnable.config.input_type(name) || 'text'
      )
    end
    Inferno::TestRunner.new(test_session:, test_run:).run(runnable)
  end

  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:test) { described_class }
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
