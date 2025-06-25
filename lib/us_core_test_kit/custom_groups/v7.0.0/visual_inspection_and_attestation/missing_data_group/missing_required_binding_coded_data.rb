module USCoreTestKit
  module USCoreV700
    class RequiredBindingUnknownHandlingTest < Inferno::Test
      title 'Handles missing data for mandatory coded elements with required binding strength'
      id :us_core_v700_att_required_binding_unknown_handling
      description %(
        The Health IT Module handles missing data for [mandatory](https://hl7.org/fhir/us/core/must-support.html#mandatory-elements) coded elements
        with required binding strength in the following ways:

        - When an "unknown" concept code from the Value Set is available
          - Using the appropriate “unknown” concept code
        - When an "unknown" concept code from the Value Set is not available
          - Using a concept from the ValueSet to maintain conformance
          - Returning a 404 and an OperationOutcome
          - When returning results from a search, excluding the resource from the search results

        Note: For the US Core profiles, the following mandatory or conditionally mandatory status elements with required binding have
        no appropriate “unknown” concept code:
        - `AllergyIntolerance.clinicalStatus`
        - `Condition.clinicalStatus`
        - `DocumentReference.status`
        - `Immunization.status`
        - `Goal.lifecycleStatus`
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@46',
                            'hl7.fhir.us.core_7.0.0@47',
                            'hl7.fhir.us.core_7.0.0@48',
                            'hl7.fhir.us.core_7.0.0@49'

      input :required_binding_unknown_handling,
            title: 'Handles missing data for required binding coded elements',
            description: %(
              The developer of the Health IT Module attests that the Health IT Module handles missing data fo
              [mandatory](https://hl7.org/fhir/us/core/must-support.html#mandatory-elements) coded elements
              with required binding strength in the following ways:

              - When an "unknown" concept code from the Value Set is available
                - Uses the appropriate “unknown” concept code
              - When an "unknown" concept code from the Value Set is not available
                - Uses a concept from the ValueSet to maintain conformance
                - Returns a 404 and an OperationOutcome
                - When returning results from a search, excludes the resource from the search results
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                { label: 'Yes', value: 'true' },
                { label: 'No', value: 'false' }
              ]
            }

      input :required_binding_unknown_handling_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert required_binding_unknown_handling == 'true',
               'Module did not demonstrate correct handling for missing data in coded elements with required binding.'
        pass required_binding_unknown_handling_note if required_binding_unknown_handling_note.present?
      end
    end
  end
end
