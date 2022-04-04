RSpec.describe USCoreTestKit::ReferenceResolutionTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

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

  describe 'reference validation with target profiles' do
    let(:reference_resolution_test) do
      Class.new(Inferno::Test) do
        include USCoreTestKit::ReferenceResolutionTest

        def self.metadata
          @metadata ||=
            USCoreTestKit::Generator::GroupMetadata.new(
              YAML.load_file(
                File.join(
                  __dir__,
                  '..',
                  'fixtures',
                  'diagnosticreport_note_metadata.yml'
                )
              )
            )
        end

        def resource_type
          'DiagnosticReport'
        end

        def scratch_resources
          scratch[:diagnostic_report_note_resources] ||= {}
        end

        fhir_client { url :url }
        input :url

        run do
          perform_reference_resolution_test(scratch_resources[:all])
        end
      end
    end
    let(:patient_ref) { 'Patient/85' }
    let(:encounter_ref) { 'Encounter/96' }
    let(:practitioner_ref) { 'Practitioner/88' }
    let(:organization_ref) { 'Organization/357' }

    let(:diagnostic_report) do
      FHIR::DiagnosticReport.new(
        subject: {
          reference: patient_ref
        },
        encounter: {
          reference: encounter_ref
        },
        performer: [
          {
            reference: practitioner_ref
          },
          {
            reference: organization_ref
          }
        ]
      )
    end

    let(:patient) do
      FHIR::Patient.new(id: '85')
    end
    let(:encounter) do
      FHIR::Encounter.new(id: '96')
    end
    let(:practitioner) do
      FHIR::Practitioner.new(id: '88')
    end
    let(:organization) do
      FHIR::Organization.new(id: '357')
    end

    before do
      Inferno::Repositories::Tests.new.insert(reference_resolution_test)
      allow_any_instance_of(reference_resolution_test)
        .to receive(:scratch_resources).and_return(
              {
                all: [diagnostic_report]
              }
            )

      stub_request(:get, "#{url}/#{patient_ref}")
        .to_return(status: 200, body: patient.to_json)
                
      stub_request(:get, "#{url}/#{practitioner_ref}")
        .to_return(status: 200, body: practitioner.to_json)
      
      stub_request(:get, "#{url}/#{organization_ref}")
        .to_return(status: 200, body: organization.to_json)
    end

    context 'when reference read returns ok' do
      before do           
        stub_request(:get, "#{url}/#{encounter_ref}")
          .to_return(status: 200, body: encounter.to_json)
      end

      it 'passes if all MS references can be read' do
        allow_any_instance_of(reference_resolution_test)
          .to receive(:resource_is_valid?).and_return(true)

        result = run(reference_resolution_test, url: url)
        expect(result.result).to eq('pass')
      end

      it 'skips if one MS references with MS target_profiles cannot be validated' do
        allow_any_instance_of(reference_resolution_test)
          .to receive(:resource_is_valid?).and_return(false)
        
        result = run(reference_resolution_test, url: url)
        expect(result.result).to eq('skip')
        expect(result.result_message).to include('performer(http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization)')
      end
    end

    context 'when reference read returns error' do
      before do
        stub_request(:get, "#{url}/#{encounter_ref}")
          .to_return(status: 401)
      end

      it 'skips if one MS references cannot be read' do
        allow_any_instance_of(reference_resolution_test)
          .to receive(:resource_is_valid?).and_return(true)

        result = run(reference_resolution_test, url: url)
        expect(result.result).to eq('skip')
        expect(result.result_message).to eq('Could not resolve Must Support references encounter')
      end
    end
  end
end
