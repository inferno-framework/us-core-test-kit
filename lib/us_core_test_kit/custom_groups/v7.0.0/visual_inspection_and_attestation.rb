require_relative 'visual_inspection_and_attestation/authenticated_api_group'

module USCoreTestKit
  module USCoreV700
    class USCoreVisualInspectionAndAttestationGroup < Inferno::TestGroup
      id :us_core_v700_visual_inspection_and_attestation
      title 'Visual Inspection and Attestation'

      description <<~DESCRIPTION
        Perform visual inspections or attestations to ensure that the Health IT Module is conformant
        to the US Core IG requirements.
      DESCRIPTION

      group from: :us_core_v700_security_group

      puts "## IDs ##"
      USCoreOptions.recursive_puts_children(self, "")

      puts "#######"
      USCoreOptions.recursive_puts_inputs(self)
      USCoreOptions.recursive_remove_input(self, :url)
      USCoreOptions.recursive_puts_inputs(self)
      puts "#######"
    end
  end
end
