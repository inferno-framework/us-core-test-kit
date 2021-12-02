require_relative 'provenance/provenance_read_test'
require_relative 'provenance/provenance_validation_test'
require_relative 'provenance/provenance_must_support_test'
require_relative 'provenance/provenance_reference_resolution_test'

module USCore
  class ProvenanceGroup < Inferno::TestGroup
    title 'Provenance Tests'
    # description ''

    id :provenance

    test from: :provenance_read_test
    test from: :provenance_validation_test
    test from: :provenance_must_support_test
    test from: :provenance_reference_resolution_test
  end
end
