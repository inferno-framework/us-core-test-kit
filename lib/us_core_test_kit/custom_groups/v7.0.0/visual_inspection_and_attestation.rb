require_relative 'visual_inspection_and_attestation/capability_statement_group'
require_relative 'visual_inspection_and_attestation/must_support_group'

module USCoreTestKit
  module USCoreV700
    class USCoreVisualInspectionAndAttestationGroup < Inferno::TestGroup
      id :us_core_v700_visual_inspection_and_attestation
      title 'Visual Inspection and Attestation'

      description <<~DESCRIPTION
        Perform visual inspections or attestations to ensure that the Health IT Module is conformant
        to the US Core IG requirements.
      DESCRIPTION

      group from: :us_core_v700_att_capability_statement
      group from: :us_core_v700_att_must_support

    end
  end
end
