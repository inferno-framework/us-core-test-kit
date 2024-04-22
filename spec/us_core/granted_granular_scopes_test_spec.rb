RSpec.describe USCoreTestKit::GrantedGranularScopesTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:required_scopes) { USCoreTestKit::SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP1['v610'] }
  let(:test) do
    described_class.config(options: { required_scopes: })
    described_class
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

  it 'passes if all required scopes were received' do
    received_scopes = required_scopes.map { |scope| scope.gsub('patient/', 'user/') }.join(' ')

    result = run(test, received_scopes:)

    expect(result.result).to eq('pass')
  end

  it 'fails if not all required scopes were received' do
    received_scopes = required_scopes.dup
    missing_scope = received_scopes.pop.delete_prefix('patient/')

    result = run(test, received_scopes: received_scopes.join(' '))

    expect(result.result).to eq('fail')
    expect(result.result_message).to include(missing_scope)
  end

  it 'fails if resource-level scopes are granted' do
    resource_level_scopes = ['patient/Condition.rs', 'patient/Patient.rs']
    received_scopes = required_scopes + resource_level_scopes

    result = run(test, received_scopes: received_scopes.join(' '))

    expect(result.result).to eq('fail')
    expect(result.result_message).to include(resource_level_scopes.first.delete_prefix('patient/') )
    expect(result.result_message).to_not include(resource_level_scopes.last.delete_prefix('patient/') )
  end

  it 'fails if wildcard scopes are granted' do
    wildcard_scopes = ['patient/*.rs', '*/*.*']
    received_scopes = required_scopes + wildcard_scopes

    result = run(test, received_scopes: received_scopes.join(' '))

    expect(result.result).to eq('fail')
    expect(result.result_message).to include(wildcard_scopes.first )
    expect(result.result_message).to include(wildcard_scopes.last )
  end
end
