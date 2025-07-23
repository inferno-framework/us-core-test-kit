RSpec.describe USCoreTestKit::GrantedGranularScopesTest do
  let(:suite_id) { 'us_core_v400' }
  let(:required_scopes) { USCoreTestKit::SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP1['v610'] }
  let(:test) do
    described_class.config(options: { required_scopes: })
    described_class
  end

  it 'passes if all required scopes were received' do
    received_scopes =
      required_scopes
        .map { |scope| scope.gsub('patient/', 'user/') }
        .join(' ')
        .concat(' launch/patient openid')

    result = run(test, received_scopes:)

    expect(result.result).to eq('pass')
  end

  it 'passes if server returns read and search scopes separately' do
    received_scopes =
      required_scopes
        .map { |scope| scope.gsub('patient/', 'user/') }
        .flat_map { |scope| [scope.gsub('.rs', '.r'), scope.gsub('.rs', '.s')] }
        .join(' ')
        .concat(' launch/patient openid')

    result = run(test, received_scopes:)
    expect(result.result).to eq('pass')
  end

  it 'fails if not all required scopes were received' do
    received_scopes = required_scopes.dup
    missing_scope = Regexp.quote(received_scopes.pop.split('?').last)

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
