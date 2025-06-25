require_relative 'must_support_group/processes_must_support'
require_relative 'must_support_group/complex_element'

module USCoreTestKit
  module USCoreV700
    class MustSupportAttestationGroup < Inferno::TestGroup
      id :us_core_v700_att_must_support
      title 'Must Support'

      run_as_group

      test from: :us_core_v700_att_ms_element_processing
      test from: :us_core_v700_att_ms_complex_and_sub_element
    end
  end
end