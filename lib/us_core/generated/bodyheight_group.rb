require_relative 'bodyheight/bodyheight_patient_code_search_test'
require_relative 'bodyheight/bodyheight_patient_category_date_search_test'
require_relative 'bodyheight/bodyheight_patient_category_status_search_test'
require_relative 'bodyheight/bodyheight_patient_code_date_search_test'
require_relative 'bodyheight/bodyheight_patient_category_search_test'
require_relative 'bodyheight/bodyheight_read_test'
require_relative 'bodyheight/bodyheight_provenance_revinclude_search_test'
require_relative 'bodyheight/bodyheight_validation_test'
require_relative 'bodyheight/bodyheight_must_support_test'
require_relative 'bodyheight/bodyheight_reference_resolution_test'

module USCore
  class BodyheightGroup < Inferno::TestGroup
    title 'Bodyheight Tests'
    # description ''

    id :bodyheight

    test from: :bodyheight_patient_code_search_test
    test from: :bodyheight_patient_category_date_search_test
    test from: :bodyheight_patient_category_status_search_test
    test from: :bodyheight_patient_code_date_search_test
    test from: :bodyheight_patient_category_search_test
    test from: :bodyheight_read_test
    test from: :bodyheight_provenance_revinclude_search_test
    test from: :bodyheight_validation_test
    test from: :bodyheight_must_support_test
    test from: :bodyheight_reference_resolution_test
  end
end
