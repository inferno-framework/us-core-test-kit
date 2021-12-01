require_relative 'bodyheight/bodyheight_patient_code_search_test'
require_relative 'bodyheight/bodyheight_status_search_test'
require_relative 'bodyheight/bodyheight_category_search_test'
require_relative 'bodyheight/bodyheight_code_search_test'
require_relative 'bodyheight/bodyheight_date_search_test'
require_relative 'bodyheight/bodyheight_patient_search_test'
require_relative 'bodyheight/bodyheight_patient_category_date_search_test'
require_relative 'bodyheight/bodyheight_patient_category_status_search_test'
require_relative 'bodyheight/bodyheight_patient_code_date_search_test'
require_relative 'bodyheight/bodyheight_patient_category_search_test'
require_relative 'bodyheight/bodyheight_read_test'
require_relative 'bodyheight/bodyheight_validation_test'

module USCore
  class BodyheightGroup < Inferno::TestGroup
    title 'Bodyheight Tests'
    # description ''

    id :bodyheight

    test from: :bodyheight_patient_code_search_test
    test from: :bodyheight_status_search_test
    test from: :bodyheight_category_search_test
    test from: :bodyheight_code_search_test
    test from: :bodyheight_date_search_test
    test from: :bodyheight_patient_search_test
    test from: :bodyheight_patient_category_date_search_test
    test from: :bodyheight_patient_category_status_search_test
    test from: :bodyheight_patient_code_date_search_test
    test from: :bodyheight_patient_category_search_test
    test from: :bodyheight_read_test
    test from: :bodyheight_validation_test
  end
end
