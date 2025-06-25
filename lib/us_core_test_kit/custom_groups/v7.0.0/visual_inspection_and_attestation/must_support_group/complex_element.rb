module USCoreTestKit
  module USCoreV700
    class MustSupportComplexAndSubElementTest < Inferno::Test
      title 'Supports Must Support complex elements and sub-elements'
      id :us_core_v700_att_ms_complex_and_sub_element
      description %(
        The Health IT Module supports Must Support behavior for complex elements and sub-elements by:

        - Being capable of providing at least one sub-element value for any complex element marked as Must Support
        - Ensuring that any sub-element marked as Must Support also satisfies the Must Support requirements for the parent element
        - Supporting sub-elements marked as Must Support when the parent is present in the resource, even if the parent itself is not marked as Must Support
        - For Must Support complex elements that have no identified Must Support sub-elements, providing a value in at least one sub-element
        - For Must Support complex elements with one or more Must Support sub-elements, providing a value in each Must Support sub-element
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@93',
                            'hl7.fhir.us.core_7.0.0@94',
                            'hl7.fhir.us.core_7.0.0@96',
                            'hl7.fhir.us.core_7.0.0@97',
                            'hl7.fhir.us.core_7.0.0@99'

      input :ms_complex_and_sub_element,
            title: 'Supports Must Support complex elements and sub-elements',
            description: %(
              The developer of the Health IT Module attests that the Health IT Module:

              - Is capable of providing at least one sub-element for any complex element marked as Must Support
              - Ensures that any sub-element marked as Must Support also meets Must Support requirements for the parent
              - Supports Must Support sub-elements when the parent is present in the resource, even if the parent is not marked Must Support
              - For Must Support complex elements that have no identified Must Support sub-elements, provides a value in at least one sub-element
              - For Must Support complex elements with one or more Must Support sub-elements, provides a value in each Must Support sub-element
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                { label: 'Yes', value: 'true' },
                { label: 'No', value: 'false' }
              ]
            }

      input :ms_complex_and_sub_element_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert ms_complex_and_sub_element == 'true',
               'Module did not demonstrate support for required Must Support behavior on complex elements and sub-elements.'
        pass ms_complex_and_sub_element_note if ms_complex_and_sub_element_note.present?
      end
    end
  end
end
