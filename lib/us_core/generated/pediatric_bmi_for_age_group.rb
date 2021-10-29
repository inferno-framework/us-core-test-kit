require_relative 'pediatric_bmi_for_age_read_test'

module USCore
  class PediatricBmiForAgeGroup < Inferno::TestGroup
    title 'PediatricBmiForAge Tests'
    # description ''

    id :pediatric_bmi_for_age

    test from: :pediatric_bmi_for_age_read_test
  end
end
