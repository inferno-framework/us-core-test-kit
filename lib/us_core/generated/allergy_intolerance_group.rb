require_relative 'allergy_intolerance/allergy_intolerance_read_test'

module USCore
  class AllergyIntoleranceGroup < Inferno::TestGroup
    title 'AllergyIntolerance Tests'
    # description ''

    id :allergy_intolerance

    test from: :allergy_intolerance_read_test
  end
end
