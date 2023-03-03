require_relative 'specimen/specimen_read_test'
require_relative 'specimen/specimen_validation_test'
require_relative 'specimen/specimen_must_support_test'

module USCoreTestKit
  module USCoreV600_BALLOT
    class SpecimenGroup < Inferno::TestGroup
      title 'Specimen Tests'
      short_description 'Verify support for the server capabilities required by the US Core Specimen Profile.'
      description %(
  # Background

The US Core Specimen sequence verifies that the system under test is
able to provide correct responses for Specimen queries. These queries
must contain resources conforming to the US Core Specimen Profile as
specified in the US Core v6.0.0-ballot Implementation Guide.

# Testing Methodology


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Specimen resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [US Core Specimen Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-specimen). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :us_core_v600_ballot_specimen
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'specimen', 'metadata.yml'), aliases: true))
      end
  
      test from: :us_core_v600_ballot_specimen_read_test
      test from: :us_core_v600_ballot_specimen_validation_test
      test from: :us_core_v600_ballot_specimen_must_support_test
    end
  end
end
