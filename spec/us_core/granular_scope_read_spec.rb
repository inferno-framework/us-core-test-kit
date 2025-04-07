RSpec.describe USCoreTestKit::GranularScopeReadTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v610') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:result) { repo_create(:result, test_session_id: test_session.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_ids) { 'PATIENT_ID'}

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

  let(:granular_scope_read_test) do
    Class.new(Inferno::Test) do
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeReadTest

      def properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'Condition',
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
        run_scope_read_test
      end
    end
  end

  before do
    Inferno::Repositories::Tests.new.insert(granular_scope_read_test)
  end
  describe "#run_scope_read_test" do

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
          id: 'DEF',
          category: {
            coding: [
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/condition-category',
                code: 'health-concern'
              }
            ]
          }
        )
      end
      let(:not_matching_resource) do
        FHIR::Condition.new(
          resourceType: 'Condition',
          id: 'GHI',
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

      let(:received_scopes) { 'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis patient/Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern' }

      context "with previous requests having available resources" do

        let!(:request) do
          repo_create(
            :request,
            url: 'http://example.com/fhir/Condition',
            test_session_id: test_session.id,
            result: repo_create(
              :result,
              test_session_id: test_session.id
            ),
            tags: ['Condition?patient&category'],
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
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource.id}")
            .to_return(body: FHIR::OperationOutcome.new().to_json, status: 401)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)

          expect(result.result).to eq('fail')
          expect(result.result_message.include?('expected 200,')).to eq(true)
        end

        it 'fails if resources which do not match the received scopes are returned' do
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource.id}")
            .to_return(body: matching_resource.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource2.id}")
            .to_return(body: matching_resource2.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{not_matching_resource.id}")
            .to_return(body: not_matching_resource.to_json)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)
          expected_message = 'Server incorrectly responded with a successful status, read should fail due to scopes.'

          expect(result.result).to eq('fail')
          expect(result.result_message).to eq(expected_message)
        end

        it 'passes if matching resource returned' do
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource.id}")
            .to_return(body: matching_resource.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource2.id}")
            .to_return(body: matching_resource2.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{not_matching_resource.id}")
            .to_return(body: FHIR::OperationOutcome.new().to_json, status: 401)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)
          expect(result.result).to eq('pass')
        end

        it 'passes if matching resource returned and no matched resource returned 401 without body' do
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource.id}")
            .to_return(body: matching_resource.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource2.id}")
            .to_return(body: matching_resource2.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{not_matching_resource.id}")
            .to_return(status: 401)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)
          expect(result.result).to eq('pass')
        end

        it 'passes if matching resource returned and no matched resource returned 401 with empty body' do
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource.id}")
            .to_return(body: matching_resource.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{matching_resource2.id}")
            .to_return(body: matching_resource2.to_json)
          stub_request(request.verb.to_sym, request.url+"/#{not_matching_resource.id}")
            .to_return(body: '', status: 401)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)
          expect(result.result).to eq('pass')
        end
      end

      context "with previous requests not populated with resource" do
        let!(:empty_request) do
          repo_create(
            :request,
            url: 'http://example.com/fhir/Condition',
            test_session_id: test_session.id,
            result: repo_create(
              :result,
              test_session_id: test_session.id
            ),
            tags: ['Condition?patient&category'],
            response_body: FHIR::Bundle.new(
              entry: [
              ]
            ).to_json
          )
        end

        it 'skips if unable to find a resource to match scopes' do
          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)

          expected_message = "Unable to find any resources to match scope #{received_scopes.split(" ").first}"

          expect(result.result).to eq("skip")
          expect(result.result_message).to eq(expected_message)
        end
      end

      context "with previous requests populated, but no out of scope resources" do
        let!(:request_with_all_matching) do
          repo_create(
            :request,
            url: 'http://example.com/fhir/Condition',
            test_session_id: test_session.id,
            result: repo_create(
              :result,
              test_session_id: test_session.id
            ),
            tags: ['Condition?patient&category'],
            response_body: FHIR::Bundle.new(
              entry: [
                { resource: matching_resource.to_hash },
                { resource: matching_resource2.to_hash }
                ]
            ).to_json
          )
        end
        it 'passes if unable to find a resource that does not match scopes, and gives info message' do
          stub_request(request_with_all_matching.verb.to_sym, request_with_all_matching.url+"/#{matching_resource.id}")
            .to_return(body: matching_resource.to_json)
          stub_request(request_with_all_matching.verb.to_sym, request_with_all_matching.url+"/#{matching_resource2.id}")
            .to_return(body: matching_resource2.to_json)

          result = run(granular_scope_read_test, url:, patient_ids:, received_scopes:)

          expected_message = "Unable to find a resource that does not match scopes."
          messages = Inferno::Repositories::Messages.new.messages_for_result(result.id).map { |message| message.message }

          expect(result.result).to eq("pass")
          expect(messages).to include(expected_message)
        end
      end
    end
  end
end
