require_relative '../../lib/us_core_test_kit/provenance_validator'

RSpec.describe USCoreTestKit::ProvenanceValidator do
  describe '.validate' do
    it 'passes when agent.who is a Practitioner and agent.onBehalfOf exists' do
      resource = FHIR::Provenance.new(
        agent:[
          {
            who: {
              reference: 'Practitioner/1'
            },
            onBehalfOf: {
              reference: 'Organization/1'
            }
          }
        ]
      )

      result = described_class.validate(resource)

      expect(result).to be_an(Array)
      expect(result.length).to eq(0)
    end

    it 'passes when agent.who is a Device and agent.onBehalfOf exists' do
      resource = FHIR::Provenance.new(
         agent:[
           {
             who: {
               reference: 'Device/1'
             },
             onBehalfOf: {
               reference: 'Organization/1'
             }
           }
         ]
      )

      result = described_class.validate(resource)

      expect(result).to be_an(Array)
      expect(result.length).to eq(0)
    end

    it 'passes when agent.who is not a Practitioner nor Device and agent.onBehalfOf does not exists' do
      resource = FHIR::Provenance.new(
         agent:[
           {
             who: {
               reference: 'Organization/1'
             }
           }
         ]
      )

      result = described_class.validate(resource)

      expect(result).to be_an(Array)
      expect(result.length).to eq(0)
    end

    it 'fails when agent.who is a Practitioner and agent.onBehalfOf does not exists' do
      resource = FHIR::Provenance.new(
         agent:[
           {
             who: {
               reference: 'Practitioner/1'
             }
           }
         ]
      )

      result = described_class.validate(resource)

      expect(result).to be_an(Array)
      expect(result.length).to eq(1)
      expect(result.first[:type]).to eq('error')
      expect(result.first[:message]).to include('Rule provenance-1')
    end

    it 'fails when agent.who is a Device and agent.onBehalfOf does not exists' do
      resource = FHIR::Provenance.new(
         id: '1',
         agent:[
           {
             who: {
               reference: 'Device/1'
             }
           }
         ]
      )

      result = described_class.validate(resource)

      expect(result).to be_an(Array)
      expect(result.length).to eq(1)
      expect(result.first[:type]).to eq('error')
      expect(result.first[:message]).to start_with('Provenance/1: Rule provenance-1')
    end
  end
end