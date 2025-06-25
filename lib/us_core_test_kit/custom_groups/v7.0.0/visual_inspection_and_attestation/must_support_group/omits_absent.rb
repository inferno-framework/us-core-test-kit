module USCoreTestKit
  module USCoreV700
    class MustSupportOmissionWhenUnknownTest < Inferno::Test
      title 'Omits missing Must Support elements when reason for absence is unknown'
      id :us_core_v700_att_ms_omit_unknown
      description %(
        The Health IT Module omits Must Support elements from a resource instance when the information is not
        present and the reason for absence is unknown.
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@78'

      input :ms_omit_unknown,
            title: 'Omits missing Must Support elements when reason for absence is unknown',
            description: %(
              The developer of the Health IT Module attests that the Health IT Module omits Must Support elements from a resource instance
              when the information is not present and the reason for absence is unknown.
            ),
            type: 'radio',
            default: 'false',
            options: { list_options: [{ label: 'Yes', value: 'true' }, { label: 'No', value: 'false' }] }

      input :ms_omit_unknown_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert ms_omit_unknown == 'true',
               'Module did not demonstrate required omission behavior for  Must Support data when the information is not present and the reason for absence is unknown.'
        pass ms_omit_unknown_note if ms_omit_unknown_note.present?
      end
    end
  end
end
