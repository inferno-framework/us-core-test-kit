require_relative 'provenance/provenance_read_test'

module USCore
  class ProvenanceGroup < Inferno::TestGroup
    title 'Provenance Tests'
    # description ''

    id :provenance

    test from: :provenance_read_test
  end
end
