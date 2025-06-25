module USCoreTestKit
  module USCoreV700
    class MissingDataExtensibleBindingTest < Inferno::Test
      title 'Handles missing data for mandatory coded elements'
      id :us_core_v700_att_missing_data_extensible

      description %(
        The Health IT Module handles missing data for [mandatory](https://hl7.org/fhir/us/core/must-support.html#mandatory-elements)
        coded elements with example, preferred, or extensible binding strengths in the following ways:

        - When only free text is available:
          - For CodeableConcept, the text is placed in the `text` element.
          - For Coding, the text is placed in the `display` element.
        - When neither a code nor free text is available:
          - An appropriate “unknown” concept code from the relevant ValueSet is used.
      )

      verifies_requirements 'hl7.fhir.us.core_7.0.0@42',
                            'hl7.fhir.us.core_7.0.0@43',
                            'hl7.fhir.us.core_7.0.0@44'

      input :missing_data_extensible,
            title: 'Handles missing data for mandatory coded elements',
            description: %(
              The developer of the Health IT Module attests that the Health IT Module handles missing data for
              [mandatory](https://hl7.org/fhir/us/core/must-support.html#mandatory-elements)
              coded elements with example, preferred, or extensible binding strengths in the following ways:

              - When only free text is available:
                - For CodeableConcept, the text is placed in the `text` element.
                - For Coding, the text is placed in the `display` element.
              - When neither a code nor free text is available:
                - An appropriate “unknown” concept code from the relevant ValueSet is used.
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                { label: 'Yes', value: 'true' },
                { label: 'No', value: 'false' }
              ]
            }

      input :missing_data_extensible_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert missing_data_extensible == 'true',
               'Module did not demonstrate support for handling missing data for extensible bindings.'
        pass missing_data_extensible_note if missing_data_extensible_note.present?
      end
    end
  end
end
