# frozen_string_literal: true

require_relative '../../lib/us_core_test_kit/custom_groups/v6.1.0/practitioner_address_test'

RSpec.describe USCoreTestKit::USCoreV610::PractitionerAddressTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('us_core_v610') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:test_class) do
    Class.new(USCoreTestKit::USCoreV610::PractitionerAddressTest) do
      fhir_client { url :url }
      input :url
      config(
        options: {
          skip_practitioner_role_validation: true
        }
      )
    end
  end
  let(:test) { test_class.new }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name:,
        value:,
        type: runnable.config.input_type(name)
      )
    end
    Inferno::TestRunner.new(test_session:, test_run:).run(runnable)
  end

  let(:practitioner_id) { '100' }
  let(:pr_id) { '200' }
  let(:practitioner) do
    FHIR::Practitioner.new(
      id: practitioner_id,
      address: [
        {
          line: ['840 Seneca St'],
          city: 'Buffalo',
          state: 'NY',
          postalCode: '14210',
          country: 'US'
        }
      ]
    )
  end
  let(:practitioner_role) do
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
  end
  let(:practitioner_role_bundle) do
    FHIR::Bundle.new(
      entry: [
        { resource: practitioner_role }
      ]
    )
  end

  describe 'practitioner address test' do
    before do
      allow_any_instance_of(test_class)
        .to receive(:scratch).and_return(
          {
            references: {
              'Practitioner' => [
                FHIR::Reference.new(reference: "Practitioner/#{practitioner_id}")
              ]
            }
          }
        )
    end

    it 'passes when practitioner has address' do
      stub_request(:get, "#{url}/Practitioner/#{practitioner_id}")
        .to_return(status: 200, body: practitioner.to_json)

      result = run(test_class, url:)
      expect(result.result).to eq('pass')
    end

    it 'passes when practitioner role is returned' do
      practitioner.address.first.country = nil

      stub_request(:get, "#{url}/Practitioner/#{practitioner_id}")
        .to_return(status: 200, body: practitioner.to_json)

      stub_request(:get, "#{url}/PractitionerRole?practitioner=#{practitioner_id}")
        .to_return(status: 200, body: practitioner_role_bundle.to_json)

      result = run(test_class, url:)
      expect(result.result).to eq('pass')
    end

    it 'fails when practitioner role is not returned and practitioner does not have all MS elements' do
      practitioner.address.first.country = nil

      stub_request(:get, "#{url}/Practitioner/#{practitioner_id}")
        .to_return(status: 200, body: practitioner.to_json)

      stub_request(:get, "#{url}/PractitionerRole?practitioner=#{practitioner_id}")
        .to_return(status: 200, body: FHIR::Bundle.new.to_json)

      result = run(test_class, url:)
      expect(result.result).to eq('fail')
      expect(result.result_message).to include('US Core PractitionerRole Profile resources')
      expect(result.result_message).to include('MustSupport elements address.country in US Core Practitioner Profile resources')
    end
  end
end
