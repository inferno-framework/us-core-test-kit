module USCoreTestKit
  module USCoreV700
    class OptionalDataOmissionTest < Inferno::Test
      title 'Omits data elements with cardinality >= 0 when data is not available'
      id :us_core_v700_att_optional_data_omission
      description %(
        The Health IT Module omits data elements from the resource when:

        - The element has a minimum cardinality of 0 (including elements labeled Must Support)
        - The source system does not have data for that element
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@39'

      input :optional_data_omission,
            title: 'Omits optional elements without available data',
            description: %(
              The developer of the Health IT Module attests that the Health IT Module omits data elements from the resource when:

              - The element has a minimum cardinality of 0 (including elements labeled Must Support)
              - The source system does not have data for that element
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                { label: 'Yes', value: 'true' },
                { label: 'No', value: 'false' }
              ]
            }

      input :optional_data_omission_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert optional_data_omission == 'true',
               'Module did not demonstrate correct omission of optional elements without available data.'
        pass optional_data_omission_note if optional_data_omission_note.present?
      end
    end
  end
end
