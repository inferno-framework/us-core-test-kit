require_relative '../../lib/us_core_test_kit/custom_groups/v4.0.0/device_udi_pi_test'

RSpec.describe USCoreTestKit::USCoreV400::DeviceUdiPiTest do
  let(:document_reference_custodian_test) { Inferno::Repositories::Tests.new.find('us_core_v400_device_udi_pi_test') }
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v400') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:device) {
    FHIR::Device.new(
      id: '1',
      udiCarrier: [ FHIR::Device::UdiCarrier.new(carrierHRF: 'udi') ]
    )
  }

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


  it 'skips if no Device saved' do
    allow_any_instance_of(document_reference_custodian_test)
      .to receive(:scratch_resources).and_return({})

    result = run(document_reference_custodian_test)
    expect(result.result).to eq('skip')
  end

  it 'passes if Device does not have UDI information' do
    device.udiCarrier = []

    allow_any_instance_of(document_reference_custodian_test)
      .to receive(:scratch_resources).and_return(
        {
          all: [ device ]
        }
      )

    result = run(document_reference_custodian_test)
    expect(result.result).to eq('pass')
  end

  it 'fails if Device has UDI information but does not have UDI-PI elements' do
    allow_any_instance_of(document_reference_custodian_test)
      .to receive(:scratch_resources).and_return(
        {
          all: [ device ]
        }
      )

    result = run(document_reference_custodian_test)
    expect(result.result).to eq('fail')
  end

  it 'passes if Device has UDI information and UDI-PI elements' do
    device.distinctIdentifier = 'udi-pi-distinct-identifier'

    allow_any_instance_of(document_reference_custodian_test)
      .to receive(:scratch_resources).and_return(
        {
          all: [ device ]
        }
      )

    result = run(document_reference_custodian_test)
    expect(result.result).to eq('pass')
  end
end