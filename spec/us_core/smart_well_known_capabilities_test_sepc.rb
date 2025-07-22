require_relative '../../lib/us_core_test_kit/custom_groups/smart_well_known_capabilities_test'

RSpec.describe USCoreTestKit::SmartWellKnownCapabilitiesTest do
  let(:suite_id) { 'us_core_v700' }
  let(:url) { 'http://example.com/fhir' }

  let(:test_class) do
    Class.new(USCoreTestKit::SmartWellKnownCapabilitiesTest) do
      fhir_client { url 'http://example.com/fhir' }
    end
  end

  describe 'SMART Well-Known Capabilities Test' do
    it 'passes when both scopes_supported and introspection_endpoints are provided' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'profile', 'launch', 'launch/patient', 'patient/*.rs', 'offline_access'],
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('pass')
    end

    it 'passes when scopes_supported has grandular scopes' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'patient/Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh'],
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('pass')
    end

    it 'passes when scopes_supported has user scope' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'profile', 'launch', 'launch/patient', 'user/*.rs', 'offline_access'],
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('pass')
    end

    it 'passes when scopes_supported has system scope' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'profile', 'launch', 'launch/patient', 'system/*.rs', 'offline_access'],
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('pass')
    end

    it 'fails when scopes_supported does not have required scope' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'profile', 'launch', 'launch/patient', 'offline_access'],
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Well-known `scopes_supported` does not have any FHIR Resource scopes: ' \
                                          '<patient|user|system>/<fhir-resource>.<c|r|u|d|s>[?param=value]')
    end

    it 'fails when smart-configureaion does not suported scope' do
      well_known_config = {
        'introspection_endpoint' => 'https://example.com/fhir/user/introspect'
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Well-known configuration does not include `scopes_supported`')
    end

    it 'fails when scopes_supported does not have introspection_endpoint' do
      well_known_config = {
        'scopes_supported' =>
          ['openid', 'profile', 'launch', 'launch/patient', 'patient/*.rs', 'offline_access']
      }

      result = run(test_class, well_known_configuration: well_known_config.to_json)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Well-known configuration does not include `introspection_endpoint`')
    end
  end
end
