RSpec.describe USCore::SearchTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, name: name, value: value)
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'search requiring status' do
    let(:status_search_test) do
      Class.new(Inferno::Test) do
        include USCore::SearchTest

        def properties
          @properties ||= USCore::SearchTestProperties.new(
            resource_type: 'Observation',
            search_param_names: ['patient'],
            possible_status_search: true
          )
        end

        def self.metadata
          @metadata ||=
            USCore::Generator::GroupMetadata.new(
              YAML.load_file(
                File.join(
                  __dir__,
                  '..',
                  'fixtures',
                  'status_search_metadata.yml'
                )
              )
            )
        end

        def scratch_resources
          scratch[:bodyheight_resources] ||= {}
        end

        fhir_client { url :url }
        input :url, :patient_ids

        run do
          run_search_test
        end
      end
    end
    let(:patient_id) { '123' }
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
          }],
        code: [
          {
            coding: [
              {
                system: 'http://loinc.org',
                code: '8302-2'
              }
            ]
          }],
        subject: {
          reference: "Patient/#{patient_id}"
        },
      )
    end
    let(:bundle) do
      FHIR::Bundle.new(entry: [{resource: observation}])
    end

    before do
      Inferno::Repositories::Tests.new.insert(status_search_test)
      allow_any_instance_of(status_search_test)
        .to receive(:scratch_resources).and_return(
              {
                all: [observation],
                patient_id => [observation]
              }
            )
    end

    it 'passes if a 200 is received' do
      stub_request(:get, "#{url}/Observation?patient=#{patient_id}")
        .to_return(status: 200, body: bundle.to_json)

      result = run(status_search_test, patient_ids: patient_id, url: url)
      expect(result.result).to eq('pass')
    end

    it 'fails if a 400 is received with no OperationOutcome' do
      stub_request(:get, "#{url}/Observation?patient=#{patient_id}")
        .to_return(status: 400, body: bundle.to_json)

      result = run(status_search_test, patient_ids: patient_id, url: url)

      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Server returned a status of 400 without an OperationOutcome')
    end

    it 'succeeds if a 400 is received with an OperationOutcome and the status search succeeds' do
      statuses = 'registered,preliminary,final,amended,corrected,cancelled,entered-in-error,unknown'
      stub_request(:get, "#{url}/Observation?patient=#{patient_id}")
        .to_return(status: 400, body: FHIR::OperationOutcome.new.to_json)
      stub_request(:get, "#{url}/Observation?patient=#{patient_id}&status=#{statuses}")
        .to_return(status: 200, body: bundle.to_json)

      result = run(status_search_test, patient_ids: patient_id, url: url)

      expect(result.result).to eq('pass')
    end
  end

  describe 'search with medication inclusion' do
    context 'when the medication resources are contained' do
      let(:patient_id) { '123' }
      let(:medication_id) { '#abc' }
      let(:medication) { FHIR::Medication.new(id: medication_id) }
      let(:medication_request) do
        FHIR::MedicationRequest.new(
          id: 'def',
          # status: 'active',
          # intent: 'order',
          medicationReference: {
            reference: medication_id
          },
          subject: {
            reference: "Patient/#{patient_id}"
          },
          contained: [
            medication
          ]
        )
      end
      let(:medication_request_search_test) do
        Class.new(Inferno::Test) do
          include USCore::SearchTest

          def properties
            @properties ||= USCore::SearchTestProperties.new(
              resource_type: 'MedicationRequest',
              search_param_names: ['patient'],
              possible_status_search: true,
              test_medication_inclusion: true,
            )
          end

          def self.metadata
            @metadata ||=
              USCore::Generator::GroupMetadata.new(
                YAML.load_file(
                  File.join(
                    __dir__,
                    '..',
                    'fixtures',
                    'medication_inclusion_metadata.yml'
                  )
                )
              )
          end

          def scratch_resources
            scratch[:medication_request_resources] ||= {}
          end

          fhir_client { url :url }
          input :url, :patient_ids

          run do
            run_search_test
          end
        end
      end
      let(:bundle) do
        FHIR::Bundle.new(entry: [{resource: medication_request}])
      end
      let(:test_scratch) { {} }

      before do
        Inferno::Repositories::Tests.new.insert(medication_request_search_test)
        allow_any_instance_of(medication_request_search_test)
          .to receive(:scratch).and_return(test_scratch)
      end

      it 'passes without performing an _include search' do
        # Match any request that doesn't contain '_include'
        stub_request(:get, /^((?!_include).)*$/)
          .to_return(status: 200, body: bundle.to_json)

        result = run(medication_request_search_test, patient_ids: patient_id, url: url)
        expect(result.result).to eq('pass')
        expect(test_scratch[:medication_resources][:all]).to include(medication)
        expect(test_scratch[:medication_resources][:contained]).to include(medication)
        expect(test_scratch[:medication_resources][patient_id]).to include(medication)
      end


    end
  end
end