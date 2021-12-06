require_relative 'provenance/provenance_read_test'
require_relative 'provenance/provenance_validation_test'
require_relative 'provenance/provenance_must_support_test'
require_relative 'provenance/provenance_reference_resolution_test'

module USCore
  class ProvenanceGroup < Inferno::TestGroup
    title 'Provenance Tests'
    description %(
# Background

The US Core Provenance sequence verifies that the system under test is
able to provide correct responses for Provenance queries. These queries
must contain resources conforming to the US Core Provenance Profile as
specified in the US Core v3.1.1 Implementation Guide.

# Testing Methodology


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Provenance resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [US Core Provenance Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
Each reference within the resources found from the previous tests must
resolve. The test will attempt to read each reference found and will
fail if any attempted read fails.

    )

    id :provenance

    test from: :provenance_read_test
    test from: :provenance_validation_test
    test from: :provenance_must_support_test
    test from: :provenance_reference_resolution_test
  end
end
