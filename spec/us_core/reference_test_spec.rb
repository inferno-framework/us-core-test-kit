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
    let(:test_class) do
      Class.new(USCoreTestKit::USCoreV400::DiagnosticReportNoteReferenceResolutionTest) do
        fhir_client { url :url }
        input :url
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
      allow_any_instance_of(test_class)
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
        allow_any_instance_of(test_class)
          .to receive(:resource_is_valid_with_target_profile?).and_return(true)

        result = run(test_class, url: url)
        expect(result.result).to eq('pass')
      end

      it 'skips if one MS references with MS target_profiles cannot be validated' do
        allow_any_instance_of(test_class)
          .to receive(:resource_is_valid_with_target_profile?).and_return(false)

        result = run(test_class, url: url)
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
        allow_any_instance_of(test_class)
          .to receive(:resource_is_valid_with_target_profile?).and_return(true)

        result = run(test_class, url: url)
        expect(result.result).to eq('skip')
        expect(result.result_message).to eq('Could not resolve Must Support references encounter')
      end
    end
  end

  describe 'reference validation without target profile' do
    let(:test_class) do
      Class.new(USCoreTestKit::USCoreV311::DocumentReferenceReferenceResolutionTest) do
        fhir_client { url :url }
        input :url
      end
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
    let(:document_reference) do
      FHIR::DocumentReference.new(
        subject: {
          reference: "Patient/#{patient.id}"
        },
        author: [
          {
            reference: "Practitioner/#{practitioner.id}"
          }
        ],
        custodian:
        {
          reference: "Practitioner/#{practitioner.id}"
        },
        context: {
          encounter: {
            reference: "Encounter/#{encounter.id}"
          }
        }
      )
    end

    before do
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
              {
                all: [document_reference]
              }
            )

      stub_request(:get, "#{url}/Patient/#{patient.id}")
        .to_return(status: 200, body: patient.to_json)

      stub_request(:get, "#{url}/Practitioner/#{practitioner.id}")
        .to_return(status: 200, body: practitioner.to_json)

      stub_request(:get, "#{url}/Encounter/#{encounter.id}")
        .to_return(status: 200, body: encounter.to_json)
    end

    it 'passes if all MS references can be read' do
      allow_any_instance_of(test_class)
        .to receive(:resource_is_valid_with_target_profile?).and_return(true)

      result = run(test_class, url: url)
      expect(result.result).to eq('pass')
    end

    it 'skips if one of MS references does not have reference value' do
      document_reference.custodian = FHIR::Reference.new(
        display: 'Example Custodian'
      )

      allow_any_instance_of(test_class)
        .to receive(:resource_is_valid_with_target_profile?).and_return(true)

      result = run(test_class, url: url)
      expect(result.result).to eq('skip')
    end
  end
end
