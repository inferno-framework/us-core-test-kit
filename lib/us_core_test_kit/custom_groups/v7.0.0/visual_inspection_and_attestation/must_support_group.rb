require_relative 'must_support_group/processes_must_support'

module USCoreTestKit
  module USCoreV700
    class MustSupportAttestationGroup < Inferno::TestGroup
      id :us_core_v700_att_must_support
      title 'Must Support'

      run_as_group

      test from: :us_core_v700_att_ms_element_processing
    end
  end
end