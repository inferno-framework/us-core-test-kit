RSpec.describe USCoreTestKit::MustSupportTest do
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

  describe 'must support test with choice elements' do
    let(:must_support_test) do
      Class.new(Inferno::Test) do
        include USCoreTestKit::MustSupportTest

        def self.metadata
          @metadata ||=
            USCoreTestKit::Generator::GroupMetadata.new(
              YAML.load_file(
                File.join(
                  __dir__,
                  '..',
                  'fixtures',
                  'device_metadata.yml'
                )
              )
            )
        end

        def resource_type
          'Device'
        end

        def scratch_resources
          scratch[:device] ||= {}
        end

        fhir_client { url :url }
        input :url

        run do
          perform_must_support_test(all_scratch_resources)
        end
      end
    end
    let(:patient_ref) { 'Patient/85' }
    let(:device) do
      FHIR::Device.new(
        udiCarrier: [
          {
              deviceIdentifier: '43069338026389'
          }
        ],
        distinctIdentifier: '43069338026389',
        manufactureDate: '2000-03-02T18:33:18-05:00',
        expirationDate: '2025-03-17T19:33:18-04:00',
        lotNumber: '1134',
        serialNumber: '842026117977',
        type: {
          text: 'Implantable defibrillator, device (physical object)'
        },
        patient: {
          reference: patient_ref
        }
      )
    end

    before do
      Inferno::Repositories::Tests.new.insert(must_support_test)
    end

    it 'fails if server supports none of the choice' do    
      allow_any_instance_of(must_support_test)
        .to receive(:scratch_resources).and_return(
              {
                all: [device]
              }
            )
      
      result = run(must_support_test, url: url)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('udiCarrier.carrierAIDC, udiCarrier.carrierHRF')
    end

    it 'passes if server supports at least one of the choice' do 
      device.udiCarrier.first.carrierHRF = '(01)43069338026389(11)000302(17)250317(10)1134(21)842026117977'
      allow_any_instance_of(must_support_test)
        .to receive(:scratch_resources).and_return(
              {
                all: [device]
              }
            )
      
      result = run(must_support_test, url: url)
      expect(result.result).to eq('pass')
    end
  end
end
