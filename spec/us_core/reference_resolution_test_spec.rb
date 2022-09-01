RSpec.describe USCoreTestKit::ReferenceResolutionTest do
  let(:test_class) do
    Class.new(Inferno::Entities::Test) do
      include USCoreTestKit::ReferenceResolutionTest

      fhir_client { url 'https://example.com/fhir' }
    end
  end

  let(:test) do
    test_class.new(scratch: {})
  end
  let(:base_url) { 'https://example.com/fhir' }

  describe '#validate_reference_resolution' do
    context 'when the reference has already been resolved' do
      let(:reference_string) { 'Encounter/123' }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }

      it 'returns true' do
        test.record_resolved_reference(reference)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(test.resolved_references).to include(reference_string)
        expect(test.requests.length).to eq(0)
      end
    end

    context 'with a reference to a contained resource' do
      let(:reference_string) { '#123' }

      it 'returns true if the contained resource is present' do
        resource =
          FHIR::Observation.new(encounter: { reference: reference_string }, contained: [FHIR::Encounter.new(id: '123')])
        reference = resource.encounter

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(test.requests.length).to eq(0)
      end

      it 'returns false if the contained resource is not present' do
        resource =
          FHIR::Observation.new(encounter: { reference: reference_string })
        reference = resource.encounter

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)

        resource =
          FHIR::Observation.new(encounter: { reference: reference_string }, contained: [FHIR::Encounter.new(id: '456')])

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(test.requests.length).to eq(0)
      end
    end

    context 'with a relative reference' do
      let(:reference_string) { 'Encounter/123' }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        request =
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(request).to have_been_made.once
        expect(test.resolved_references).to include(reference_string)
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with an absolute reference to the same server' do
      let(:reference_string) { "#{base_url}/Encounter/123" }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with an absolute reference to a different server' do
      let(:reference_string) { "https://example.org/fhir/Encounter/123" }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with a target profile' do
      context 'with a contained reference' do
        let(:reference_string) { '#123' }
        let(:contained_resource) { FHIR::Encounter.new(id: '123') }
        let(:resource) { FHIR::Observation.new(encounter: { reference: reference_string }, contained: [contained_resource]) }
        let(:reference) { resource.encounter }

        it 'returns true if the contained resource conforms to the target profile' do
          allow(test).to receive(:resource_is_valid?).with(resource: contained_resource, profile_url: 'PROFILE').and_return(true)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(true)
        end

        it 'returns false if the contained resource does not conform to the target profile' do
          allow(test).to receive(:resource_is_valid?).with(resource: contained_resource, profile_url: 'PROFILE').and_return(false)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(false)
        end
      end

      context 'with a non-contained reference' do
        let(:reference_string) { 'Encounter/123' }
        let(:resource) do
          FHIR::Observation.new(encounter: { reference: reference_string })
        end
        let(:reference) { resource.encounter }
        let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

        before do
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 200, body: referenced_resource.to_json)
        end

        it 'returns true if the referenced resource conforms to the target profile' do
          allow(test).to receive(:resource_is_valid?).with(resource: referenced_resource, profile_url: 'PROFILE').and_return(true)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(true)
        end

        it 'returns false if the referenced resource does not conform to the target profile' do
          allow(test).to receive(:resource_is_valid?).with(resource: referenced_resource, profile_url: 'PROFILE').and_return(false)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(false)
        end
      end
    end
  end

end
