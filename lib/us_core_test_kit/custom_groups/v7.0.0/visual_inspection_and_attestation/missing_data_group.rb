require_relative 'missing_data_group/missing_0_card_data'
require_relative 'missing_data_group/missing_coded_data'
require_relative 'missing_data_group/missing_required_binding_coded_data'

module USCoreTestKit
  module USCoreV700
    class MissingDataAttestationGroup < Inferno::TestGroup
      id :us_core_v700_att_missing_data
      title 'Missing Data'

      run_as_group

      test from: :us_core_v700_att_optional_data_omission
      test from: :us_core_v700_att_missing_data_extensible
      test from: :us_core_v700_att_required_binding_unknown_handling
    end
  end
end