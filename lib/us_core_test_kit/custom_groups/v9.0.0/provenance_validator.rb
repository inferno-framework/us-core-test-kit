require_relative '../../provenance_validator'

module USCoreTestKit
  module USCoreV900
    # Replace the known invalid provenance-1 FHIRPath expression with a type check.
    class ProvenanceValidator < USCoreTestKit::ProvenanceValidator
      def validate
        return validation_messages unless resource.instance_of?(FHIR::Provenance)

        failed = resource.agent.any? do |agent|
          reference = agent.who
          type = if reference&.contained?
                   resource.contained.find { |contained| contained.id == reference.reference_id }&.resourceType
                 else
                   reference&.resource_type || reference&.type&.split('/')&.last
                 end
          ['Practitioner', 'Device'].include?(type) && agent.onBehalfOf.nil?
        end

        if failed
          validation_messages << {
            type: 'error',
            message: "#{resource.resourceType}/#{resource.id}: Rule provenance-1: " \
                     "'onBehalfOf SHALL be present when Provenance.agent.who is a Practitioner or Device' Failed"
          }
        end

        validation_messages
      end
    end
  end
end
