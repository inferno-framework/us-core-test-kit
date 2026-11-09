require 'rack/mock'

RSpec.describe 'US Core v9 client assembly', :runnable do
  let(:suite_id) { 'us_core_client_v900' }
  let(:test_session) do
    repo_create(:test_session, test_suite_id: suite_id,
                suite_options: [Inferno::DSL::SuiteOption.new(id: :client_type,
                                                          value: SMARTAppLaunch::SMARTClientOptions::SMART_APP_LAUNCH_PUBLIC)])
  end
  let(:read_search) { suite.groups.find { |group| group.id.to_s.end_with?('us_core_client_read_search_group_v900') } }
  let(:profiles) { read_search.groups.reject { |group| group.id.to_s.end_with?('us_core_client_access_group_v900') } }
  let(:fixture_root) { File.expand_path('../../lib/us_core_test_kit/client/fixtures/v9.0.0', __dir__) }
  let(:manifest) { JSON.parse(File.read(File.join(fixture_root, 'manifest.json'))) }
  let(:capture_result) do
    repo_create(:result, test_session_id: test_session.id, runnable: { test_id: find_test(suite, 'us_core_client_wait_test_v900').id })
  end

  def find_client_test(group, suffix)
    profiles.find { |candidate| candidate.id.to_s.end_with?("us_core_client_v900_#{group}") }
      .tests.find { |test| test.id.to_s.end_with?(suffix) }
  end

  def incoming(url, tags:, verb: 'get', body: nil)
    repo_create(:request, test_session_id: test_session.id, result: capture_result, direction: 'incoming', url: url,
                verb: verb, request_body: body, tags: tags, response_body: '{}')
  end

  it 'loads all 53 profiles with unique v9 IDs and complete fixture/catalog coverage' do
    expect(profiles.length).to eq(53)
    expect(profiles.flat_map(&:tests).map(&:id).uniq.length).to eq(332)
    expect(profiles.flat_map(&:tests).map(&:id).join).not_to include('v800')
    catalog = JSON.parse(USCoreTestKit::Client::USCoreClientV900::MetadataHelper.get_metadata.call[2].join)
    advertised = catalog['rest'][0]['resource'].flat_map { |resource| resource['supportedProfile'] }
    expect(advertised.sort).to eq(manifest.map { |row| row['profile'] }.sort)
    expect(catalog['implementation']['url']).to include('us_core_client_v900')
  end

  it 'evaluates all 332 profile tests against captured GET and POST request records' do
    captured_searches = Set.new
    manifest.each do |row|
      type = row['resource_type']
      group = profiles.find { |candidate| candidate.id.to_s.end_with?("us_core_client_v900_#{row['group']}") }
      group.tests.each_with_index do |test, index|
        instance = test.new
        if test.id.to_s.end_with?('_client_read_test')
          tags = USCoreTestKit::Client::USCoreClientV900::ReadEndpoint.new.resource_to_tag(type)
          incoming("http://example.com/fhir/#{type}/#{row['id']}", tags: [tags])
        else
          key = [type, instance.required_params.sort]
          next if captured_searches.include?(key)

          captured_searches.add(key)
          params = instance.required_params.to_h { |param| [param, 'test-value'] }
          tags = USCoreTestKit::Client::USCoreClientV900::SearchEndpoint.new.resource_to_tag(type)
          if index.even?
            incoming("http://example.com/fhir/#{type}?#{URI.encode_www_form(params)}", tags: [tags])
          else
            incoming("http://example.com/fhir/#{type}/_search", tags: [tags], verb: 'post', body: URI.encode_www_form(params))
          end
        end
      end
    end
    outcomes = profiles.flat_map(&:tests).map do |test|
      instance = test.new(test_session_id: test_session.id)
      begin
        instance.instance_eval(&test.block)
        [test.id, 'pass']
      rescue StandardError => error
        [test.id, error.message]
      end
    end
    expect(outcomes.reject { |_id, status| status == 'pass' }).to be_empty
  end

  it 'fails an incorrect FamilyMemberHistory read ID' do
    incoming('http://example.com/fhir/FamilyMemberHistory/wrong-id', tags: ['us_core_family_member_history_read'])
    result = run(find_client_test('family_member_history', 'family_member_history_client_read_test'))
    expect(result.result).to eq('fail')
  end

  it 'fails a required family-history search missing patient but keeps patient+code optional' do
    incoming('http://example.com/fhir/FamilyMemberHistory?code=709044004', tags: ['us_core_family_member_history_search'])
    result = run(find_client_test('family_member_history', 'family_member_history_patient_client_search_test'))
    expect(result.result).to eq('fail')
    recommended = find_client_test('family_member_history', 'family_member_history_patient_code_client_search_test')
    expect(recommended.optional?).to be(true)
  end

  it 'does not require Device to be the passing group' do
    instance = read_search.new
    device = profiles.find { |group| group.id.to_s.end_with?('_device') }
    patient = profiles.find { |group| group.id.to_s.end_with?('_patient') }
    allow(instance).to receive(:results).and_return({ patient.id => Struct.new(:result).new('pass'), device.id => Struct.new(:result).new('skip') })
    expect { instance.instance_eval(&read_search.block) }.not_to raise_error
    allow(instance).to receive(:results).and_return({})
    expect { instance.instance_eval(&read_search.block) }.to raise_error(Inferno::Exceptions::AssertionException)
  end

  it 'rejects passing Client Access when all 53 profile groups are skipped' do
    access = read_search.groups.find { |group| group.id.to_s.end_with?('us_core_client_access_group_v900') }
    outcomes = profiles.to_h { |group| [group.id, Struct.new(:result).new('skip')] }
    outcomes[access.id] = Struct.new(:result).new('pass')
    instance = read_search.new
    allow(instance).to receive(:results).and_return(outcomes)

    expect { instance.instance_eval(&read_search.block) }
      .to raise_error(Inferno::Exceptions::AssertionException, 'At least one profile group must pass.')
  end

  %w[json application/fhir%2Bjson application%2Ffhir%2Bjson].each do |format|
    {
      'us-core-client-tests-patient' => 'pass',
      'US-CORE-CLIENT-TESTS-PATIENT' => 'fail'
    }.each do |id, expected|
      it "#{expected == 'pass' ? 'accepts the exact' : 'rejects a differently cased'} Patient read ID with _format=#{format}" do
        incoming("http://example.com/fhir/Patient/#{id}?_format=#{format}", tags: ['us_core_patient_read'])

        expect(run(find_client_test('patient', 'patient_client_read_test')).result).to eq(expected)
      end
    end
  end

  {
    'us-core-client-tests-observation-clinical-result' => 'pass',
    'us-core-client-tests-observation-lab' => 'pass',
    'US-CORE-CLIENT-TESTS-OBSERVATION-LAB' => 'fail'
  }.each do |id, expected|
    it "#{expected == 'pass' ? 'accepts' : 'rejects'} the Clinical Result read target #{id}" do
      incoming("http://example.com/fhir/Observation/#{id}", tags: ['us_core_observation_read'])

      expect(run(find_client_test('observation_clinical_result', 'observation_clinical_result_client_read_test')).result)
        .to eq(expected)
    end
  end

  it 'issues OpenID claims under the v9 client URLs advertised by discovery' do
    client_id = 'oidc-client-v9'
    redirect_uri = 'https://client.test/callback'
    wait_test = find_test(suite, 'us_core_client_wait_test_v900')
    expect(run(wait_test, client_id: client_id,
                          fhir_user_relative_reference: 'Patient/us-core-client-tests-patient').result).to eq('wait')
    app = Inferno::Utils::Middleware::RequestLogger.new(Inferno::Web.app)
    base = '/custom/us_core_client_v900'
    params = { response_type: 'code', client_id: client_id, redirect_uri: redirect_uri,
               scope: 'openid fhirUser', state: 'test-state' }
    env = Rack::MockRequest.env_for("http://example.com#{base}/auth/authorization?#{URI.encode_www_form(params)}")
    env['REQUEST_PATH'] = "#{base}/auth/authorization"
    status, headers, = app.call(env)
    expect(status).to eq(302)
    code = URI.decode_www_form(URI(headers['Location'] || headers['location']).query).to_h.fetch('code')
    body = URI.encode_www_form(grant_type: 'authorization_code', code: code,
                               client_id: client_id, redirect_uri: redirect_uri)
    env = Rack::MockRequest.env_for("http://example.com#{base}/auth/token", method: 'POST', input: body,
                                   'CONTENT_TYPE' => 'application/x-www-form-urlencoded')
    env['REQUEST_PATH'] = "#{base}/auth/token"
    status, _headers, response = app.call(env)
    expect(status).to eq(200), response.to_a.join
    claims = JWT.decode(JSON.parse(response.to_a.join).fetch('id_token'), nil, false).first
    issuer = JSON.parse(SMARTAppLaunch::MockSMARTServer.openid_connect_metadata(suite_id)[2].join)['issuer']
    expect(claims['iss']).to eq(issuer)
    expect(claims['fhirUser']).to eq("#{issuer}/Patient/us-core-client-tests-patient")
    expect(claims['aud']).to eq(client_id)
  end

  [true, false].each do |trailing_slash|
    it "preserves FHIR URL boundaries with a#{trailing_slash ? '' : ' non'}-trailing-slash upstream base" do
      original = ENV['FHIR_REFERENCE_SERVER']
      ENV['FHIR_REFERENCE_SERVER'] = 'http://reference.test/fhir' + (trailing_slash ? '/' : '')
      endpoint = USCoreTestKit::Client::USCoreClientV900::SearchEndpoint.new
      bundle = FHIR::Bundle.new(
        type: 'searchset',
        link: [{ relation: 'next', url: 'http://reference.test/fhir/FamilyMemberHistory?_page=2' }],
        entry: [{ fullUrl: 'http://reference.test/fhir/FamilyMemberHistory/f1' }]
      )
      rewritten = endpoint.replace_bundle_urls(bundle)
      base = "#{Inferno::Application['base_url']}/custom/us_core_client_v900/fhir"
      expect(rewritten.link.first.url).to eq("#{base}/FamilyMemberHistory?_page=2")
      expect(rewritten.entry.first.fullUrl).to eq("#{base}/FamilyMemberHistory/f1")
    ensure
      ENV['FHIR_REFERENCE_SERVER'] = original
    end
  end

  [:get, :post, :read].each do |interaction|
    it "captures a FamilyMemberHistory #{interaction} request through the registered endpoint" do
      old_reference = ENV['FHIR_REFERENCE_SERVER']
      ENV['FHIR_REFERENCE_SERVER'] = 'http://reference.test/fhir/'
      wait_test = find_test(suite, 'us_core_client_wait_test_v900')
      expect(run(wait_test, client_id: 'client-v9').result).to eq('wait')
      token = SMARTAppLaunch::MockSMARTServer.client_id_to_token('client-v9', 10)
      target = manifest.find { |row| row['group'] == 'family_member_history' }
      bundle = JSON.parse(File.read(File.join(fixture_root, 'bundle.json')))
      resource = bundle['entry'].find { |entry| entry['resource']['id'] == target['id'] }['resource']
      params = { 'patient' => 'us-core-client-tests-patient', 'code' => '709044004' }
      if interaction == :read
        upstream = "http://reference.test/fhir/FamilyMemberHistory/#{target['id']}"
        stub_request(:get, upstream).to_return(status: 200, headers: { 'Content-Type' => 'application/fhir+json' }, body: resource.to_json)
        path = "/custom/us_core_client_v900/fhir/FamilyMemberHistory/#{target['id']}"
        method = 'GET'
        body = nil
      else
        stub_request(:get, 'http://reference.test/fhir/FamilyMemberHistory').with(query: params)
          .to_return(status: 200, headers: { 'Content-Type' => 'application/fhir+json' }, body: { resourceType: 'Bundle', type: 'searchset', entry: [{ fullUrl: "http://reference.test/fhir/FamilyMemberHistory/#{target['id']}", resource: resource }] }.to_json)
        path = '/custom/us_core_client_v900/fhir/FamilyMemberHistory'
        path += interaction == :post ? '/_search' : "?#{URI.encode_www_form(params)}"
        method = interaction == :post ? 'POST' : 'GET'
        body = interaction == :post ? URI.encode_www_form(params) : nil
      end
      app = Inferno::Utils::Middleware::RequestLogger.new(Inferno::Web.app)
      env = Rack::MockRequest.env_for("http://example.com#{path}", method: method, input: body.to_s,
                                     'HTTP_AUTHORIZATION' => "Bearer #{token}", 'CONTENT_TYPE' => 'application/x-www-form-urlencoded')
      env['REQUEST_PATH'] = path.split('?').first
      status, _headers, response_body = app.call(env)
      expect(status).to eq(200), response_body.to_a.join
      tags = interaction == :read ? ['us_core_family_member_history_read'] : ['us_core_family_member_history_search']
      captured = Inferno::Repositories::Requests.new.tagged_requests(test_session.id, tags)
      expect(captured.length).to eq(1)
      expect(captured.first.direction).to eq('incoming')
      test = interaction == :read ? find_client_test('family_member_history', 'family_member_history_client_read_test') : find_client_test('family_member_history', 'family_member_history_patient_code_client_search_test')
      expect(run(test).result).to eq('pass')
    ensure
      ENV['FHIR_REFERENCE_SERVER'] = old_reference
    end
  end
end
