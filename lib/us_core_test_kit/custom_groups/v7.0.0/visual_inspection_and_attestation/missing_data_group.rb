require_relative 'missing_data_group/missing_coded_data'

module USCoreTestKit
  module USCoreV700
    class MissingDataAttestationGroup < Inferno::TestGroup
      id :us_core_v700_att_missing_data
      title 'Missing Data'

      run_as_group

      test from: :us_core_v700_att_missing_data_extensible
    end
  end
end