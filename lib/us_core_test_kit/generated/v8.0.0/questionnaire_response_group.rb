require_relative 'questionnaire_response/questionnaire_response_patient_search_test'
require_relative 'questionnaire_response/questionnaire_response_id_search_test'
require_relative 'questionnaire_response/questionnaire_response_patient_authored_search_test'
require_relative 'questionnaire_response/questionnaire_response_patient_status_search_test'
require_relative 'questionnaire_response/questionnaire_response_patient_questionnaire_search_test'
require_relative 'questionnaire_response/questionnaire_response_read_test'
require_relative 'questionnaire_response/questionnaire_response_provenance_revinclude_search_test'
require_relative 'questionnaire_response/questionnaire_response_validation_test'
require_relative 'questionnaire_response/questionnaire_response_must_support_test'
require_relative 'questionnaire_response/questionnaire_response_reference_resolution_test'

module USCoreTestKit
  module USCoreV800
    class QuestionnaireResponseGroup < Inferno::TestGroup
      title 'QuestionnaireResponse Tests'
      short_description 'Verify support for the server capabilities required by the US Core QuestionnaireResponse Profile.'
      description %(
  # Background

The US Core QuestionnaireResponse sequence verifies that the system under test is
able to provide correct responses for QuestionnaireResponse queries. These queries
must contain resources conforming to the US Core QuestionnaireResponse Profile as
specified in the US Core v8.0.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* patient
* _id

### Search Parameters
The first search uses the selected patient(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the patient sequence is performed by looking for an existing
`Patient.identifier` from any of the resources returned in the `_id`
search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
QuestionnaireResponse resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Patient search for `gender=male` returns a `female`
patient.


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the QuestionnaireResponse resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [US Core QuestionnaireResponse Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse). Each element is checked against
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

      id :us_core_v800_questionnaire_response
      run_as_group
      optional
      
      verifies_requirements 'hl7.fhir.us.core_8.0.0@511'

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'questionnaire_response', 'metadata.yml'), aliases: true))
      end
  
      test from: :us_core_v800_questionnaire_response_patient_search_test
      test from: :us_core_v800_questionnaire_response__id_search_test
      test from: :us_core_v800_questionnaire_response_patient_authored_search_test
      test from: :us_core_v800_questionnaire_response_patient_status_search_test
      test from: :us_core_v800_questionnaire_response_patient_questionnaire_search_test
      test from: :us_core_v800_questionnaire_response_read_test
      test from: :us_core_v800_questionnaire_response_provenance_revinclude_search_test
      test from: :us_core_v800_questionnaire_response_validation_test
      test from: :us_core_v800_questionnaire_response_must_support_test
      test from: :us_core_v800_questionnaire_response_reference_resolution_test
    end
  end
end
