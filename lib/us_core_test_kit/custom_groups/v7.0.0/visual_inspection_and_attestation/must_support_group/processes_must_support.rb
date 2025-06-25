module USCoreTestKit
  module USCoreV700
    class MustSupportElementProcessingTest < Inferno::Test
      title 'Processes Must Support and Mandatory elements'
      id :us_core_v700_att_ms_element_processing
      description %(
        The Health IT Module is able to process [Must Support](https://hl7.org/fhir/us/core/must-support.html)
        and [Mandatory](https://hl7.org/fhir/us/core/must-support.html#mandatory-elements) elements.
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@31'

      input :ms_element_processing,
            title: 'Processes Must Support and Mandatory elements',
            description: %(
            I attest that the Health IT Module is able to process [Must Support](https://hl7.org/fhir/us/core/must-support.html)
            and [Mandatory](https://hl7.org/fhir/us/core/must-support.html) elements.
            ),
            type: 'radio',
            default: 'false',
            options: { list_options: [{ label: 'Yes', value: 'true' }, { label: 'No', value: 'false' }] }

      input :ms_element_processing_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert ms_element_processing == 'true',
               'Module did not demonstrate support for processing Must Support and Mandatory elements.'
        pass ms_element_processing_note if ms_element_processing_note.present?
      end
    end
  end
end