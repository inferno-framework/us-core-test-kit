require_relative 'care_plan/care_plan_patient_category_search_test'
require_relative 'care_plan/care_plan_patient_category_status_date_search_test'
require_relative 'care_plan/care_plan_patient_category_status_search_test'
require_relative 'care_plan/care_plan_patient_category_date_search_test'
require_relative 'care_plan/care_plan_read_test'
require_relative 'care_plan/care_plan_provenance_revinclude_search_test'
require_relative 'care_plan/care_plan_validation_test'
require_relative 'care_plan/care_plan_must_support_test'
require_relative 'care_plan/care_plan_reference_resolution_test'

module USCore
  class CarePlanGroup < Inferno::TestGroup
    title 'CarePlan Tests'
    description %(
# Background

The US Core CarePlan sequence verifies that the system under test is
able to provide correct responses for CarePlan queries. These queries
must contain resources conforming to the US Core CarePlan Profile as
specified in the US Core v3.1.1 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* patient + category

### Search Parameters
The first search uses the selected patient(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the patient sequence is performed by looking for an existing
`Patient.identifier` from any of the resources returned in the `_id`
search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
CarePlan resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Patient search for `gender=male` returns a `female`
patient.


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the CarePlan resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [US Core CarePlan Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
Each reference within the resources found from the previous tests must
resolve. The test will attempt to read each reference found and will
fail if any attempted read fails.

    )

    id :care_plan

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'care_plan', 'metadata.yml')))
    end

    test from: :care_plan_patient_category_search_test
    test from: :care_plan_patient_category_status_date_search_test
    test from: :care_plan_patient_category_status_search_test
    test from: :care_plan_patient_category_date_search_test
    test from: :care_plan_read_test
    test from: :care_plan_provenance_revinclude_search_test
    test from: :care_plan_validation_test
    test from: :care_plan_must_support_test
    test from: :care_plan_reference_resolution_test
  end
end
