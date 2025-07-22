RSpec.describe USCoreTestKit::GranularScopeSearchTest do
  let(:suite_id) { 'us_core_v610' }
  let(:result) { repo_create(:result, test_session_id: test_session.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_ids) { 'PATIENT_ID'}

  let(:granular_scope_test) do
    Class.new(Inferno::Test) do
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeSearchTest

      def properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'Condition',
          search_param_names: ['patient']
        )
      end

      def self.metadata
        @metadata ||=
          USCoreTestKit::Generator::GroupMetadata.new(
            YAML.load_file(
              File.join(
                __dir__,
                '..',
                'fixtures',
                'granular_scope_metadata.yml'
              )
            )
          )
      end

      fhir_client { url :url }
      input :url, :patient_ids

      run do
        run_scope_search_test
      end
    end
  end

  before do
    Inferno::Repositories::Tests.new.insert(granular_scope_test)
  end

  describe '#run_scope_check_test' do
    let(:received_scopes) { 'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis' }

    context 'when no previous searches match the search parameters' do
      it 'skips' do
        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expect(result.result).to eq('skip')
        expect(result.result_message).to match(/No Condition searches with search params/)
      end
    end

    context 'when previous searches do match the search parameters' do
      let(:matching_resource) do
        FHIR::Condition.new(
          resourceType: 'Condition',
          id: 'ABC',
          category: {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                code: 'encounter-diagnosis'
              }
            ]
          }
        )
      end
      let(:matching_resource2) do
        FHIR::Condition.new(
          resourceType: 'Condition',
          id: 'GHI',
          category: {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                code: 'encounter-diagnosis'
              }
            ]
          }
        )
      end
      let(:not_matching_resource) do
        FHIR::Condition.new(
          resourceType: 'Condition',
          id: 'DEF',
          category: {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                code: 'problem-list-item'
              }
            ]
          }
        )
      end
      let!(:request) do
        repo_create(
          :request,
          url: 'http://example.com/fhir/Condition?patient=PATIENT_ID',
          test_session_id: test_session.id,
          result: repo_create(
            :result,
            test_session_id: test_session.id
          ),
          tags: ['Condition?patient'],
          response_body: FHIR::Bundle.new(
            entry: [
              { resource: matching_resource.to_hash },
              { resource: matching_resource2.to_hash },
              { resource: not_matching_resource.to_hash }
            ]
          ).to_json
        )
      end

      it 'fails if resources which match the received scopes are not returned' do
        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: FHIR::Bundle.new.to_json)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expected_message = "Resources with the following ids were received when using resource-level scopes, " \
                          "but not when using granular scopes: #{matching_resource.id}, #{matching_resource2.id}"

        expect(result.result).to eq('fail')
        expect(result.result_message).to eq(expected_message)
      end

      it 'fails if resources which do not match the received scopes are returned' do
        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: request.response_body)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expected_message = "Resources with the following ids were received even though they do not match the " \
                          "granted granular scopes: #{not_matching_resource.id}"

        expect(result.result).to eq('fail')
        expect(result.result_message).to eq(expected_message)
      end

      it 'fails if not all matching resources are returned' do
        response_body =
          FHIR::Bundle.new(
            entry: [
              { resource: matching_resource.to_hash }
            ]
          ).to_json
        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: response_body)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expected_message = "Resources with the following ids were received when using resource-level scopes, " \
                           "but not when using granular scopes: #{matching_resource2.id}"

        expect(result.result).to eq('fail')
        expect(result.result_message).to eq(expected_message)
      end

      it 'fails if extra matching resources are returned' do
        matching_resource3 =
          FHIR::Condition.new(
            resourceType: 'Condition',
            id: 'JKL',
            category: {
              coding: [
                {
                  system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                  code: 'encounter-diagnosis'
                }
              ]
            }
          )
        response_body =
          FHIR::Bundle.new(
            entry: [
              { resource: matching_resource.to_hash },
              { resource: matching_resource2.to_hash },
              { resource: matching_resource3.to_hash }
            ]
          ).to_json

        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: response_body)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expected_message = "Resources with the following ids were received when using granular scopes, " \
                           "but not when using resource-level scopes: #{matching_resource3.id}"

        expect(result.result).to eq('fail')
        expect(result.result_message).to eq(expected_message)
      end

      it 'passes if all resources which do match the received scopes are returned' do
        response_body =
          FHIR::Bundle.new(
            entry: [
              { resource: matching_resource.to_hash },
              { resource: matching_resource2.to_hash }
            ]
          ).to_json
        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: response_body)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

        expect(result.result).to eq('pass')
      end

      it 'passes if an OperationOutcome is included among matching resources' do
        response_body =
          FHIR::Bundle.new(
            entry: [
              { resource: matching_resource.to_hash },
              { resource: matching_resource2.to_hash },
              { resource: FHIR::OperationOutcome.new(id: "OperationOutcomeID") }
            ]
          ).to_json
        stub_request(request.verb.to_sym, request.url.split('?').first)
          .with(query: request.query_parameters)
          .to_return(body: response_body)

        result = run(granular_scope_test, url:, patient_ids:, received_scopes:)
        expect(result.result).to eq('pass')
      end

      context 'with POST requests' do
        let!(:post_request) do
          repo_create(
            :request,
            url: 'http://example.com/fhir/Condition/_search',
            verb: 'post',
            test_session_id: test_session.id,
            result: repo_create(
              :result,
              test_session_id: test_session.id
            ),
            tags: ['Condition?patient'],
            request_body: URI.encode_www_form({patient: patient_ids}),
            response_body: FHIR::Bundle.new(
              entry: [
                { resource: matching_resource.to_hash },
                { resource: matching_resource2.to_hash },
                { resource: not_matching_resource.to_hash }
              ]
            ).to_json
          )
        end

        it 'correctly pulls parameters from POST body' do
          response_body =
            FHIR::Bundle.new(
              entry: [
                { resource: matching_resource.to_hash },
                { resource: matching_resource2.to_hash }
              ]
            ).to_json

          stub_request(:post, post_request.url)
            .with(body: {patient: patient_ids})
            .to_return(body: response_body)

          result = run(granular_scope_test, url:, patient_ids:, received_scopes:)

          expect(result.result).to eq('pass')
        end
      end
    end
  end
end
