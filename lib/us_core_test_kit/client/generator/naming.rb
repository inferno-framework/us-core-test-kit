module USCoreTestKit
  module Client
    class Generator
      module Naming
        ID_SPECIAL_CASE = {
          # v3.1.1 profile naming mismatches
          'condition' => 'condition-encounter-diagnosis',
          'head-circumference' => 'head-circumference-percentile',
          'bodyheight' => 'body-height',
          'bodytemp' => 'body-temperature',
          'bp' => 'blood-pressure',
          'bodyweight' => 'body-weight',
          'heartrate' => 'heart-rate',
          'resprate' => 'respiratory-rate'
        }.freeze

        class << self
          def instance_id_for_profile_identifier(profile_identifier)
            suffix = profile_identifier.underscore.dasherize
            if ID_SPECIAL_CASE.key?(suffix)
              suffix = ID_SPECIAL_CASE[suffix]
            end
            
            "us-core-client-tests-#{suffix}"
          end
        end
      end
    end
  end
end
