require_relative '../../lib/us_core_test_kit/custom_groups/v6.1.0/practitioner_address_test'

RSpec.describe USCoreTestKit::USCoreV610::PractitionerAddressTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v610') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:test) { described_class }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name: name,
        value: value,
        type: runnable.config.input_type(name) || 'text'
      )
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  let(:practitioner_id) { '100' }
  let(:pr_id) { '200' }
  let(:practitioner) {
    FHIR::Practitioner.new(
      id: practitioner_id,
      address: [
        {
          line: [ "840 Seneca St" ],
          city: 'Buffalo',
          state: 'NY',
          postalCode: '14210',
          country: 'US'
        }
      ]
    )
  }
  let(:practitioner_role) {
    FHIR::PractitionerRole.new(
      id: pr_id,
      practitioner: {
        reference: "Practitioner/#{practitioner_id}"
      },
      telecom: {
        system: 'phone',
        value: '555-1234'
      }
    )
  }
  let(:practitioner_role_bundle) {
    FHIR::Bundle.new(
      entry: [
        practitioner_role
      ]
    )
  }

  describe 'practitioner address test' do
    it 'passes when practitioner has address' do
      allow_any_instance_of(test)
        .to receive(:scratch).and_return(
          {
            references: {
              'Practitioner' => [
                FHIR::Reference.new(reference: "Practitioner/#{practitioner_id}")
              ]
            }
          }
        )
      result = run(test, url:)
      binding.pry
      expect(result.result).to eq('pass')
    end

    # it 'passes when practitioner role is returned' do
    #   practitioner.address = nil
    #   allow_any_instance_of(test)
    #     .to receive(:scratch_resources).and_return(
    #       {
    #         all: [practitioner]
    #       }
    #     )

    #   stub_request(:get, "#{url}/PractitionerRole?practitioner=#{practitioner_id}")
    #     .to_return(status: 200, body: practitioner_role_bundle.to_json)
    #   result = run(test, url:)
    #   binding.pry
    #   expect(result.result).to eq('pass')
    # end

  end
end