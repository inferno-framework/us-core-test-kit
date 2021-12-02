require_relative 'pulse_oximetry/pulse_oximetry_patient_code_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_category_date_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_category_status_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_code_date_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_patient_category_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_read_test'
require_relative 'pulse_oximetry/pulse_oximetry_provenance_revinclude_search_test'
require_relative 'pulse_oximetry/pulse_oximetry_validation_test'
require_relative 'pulse_oximetry/pulse_oximetry_must_support_test'

module USCore
  class PulseOximetryGroup < Inferno::TestGroup
    title 'PulseOximetry Tests'
    # description ''

    id :pulse_oximetry

    test from: :pulse_oximetry_patient_code_search_test
    test from: :pulse_oximetry_patient_category_date_search_test
    test from: :pulse_oximetry_patient_category_status_search_test
    test from: :pulse_oximetry_patient_code_date_search_test
    test from: :pulse_oximetry_patient_category_search_test
    test from: :pulse_oximetry_read_test
    test from: :pulse_oximetry_provenance_revinclude_search_test
    test from: :pulse_oximetry_validation_test
    test from: :pulse_oximetry_must_support_test
  end
end
