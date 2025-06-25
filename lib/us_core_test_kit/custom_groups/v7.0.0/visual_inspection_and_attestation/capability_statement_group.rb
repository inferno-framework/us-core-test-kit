require_relative 'capability_statement_group/specifies_capabilities'

module USCoreTestKit
  module USCoreV700
    class CapabilityStatementAttestationGroup < Inferno::TestGroup
      id :us_core_v700_att_capability_statement
      title 'Capability Statement'

      run_as_group

      test from: :us_core_v700_att_capability_details
    end
  end
end