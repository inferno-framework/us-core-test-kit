module USCoreTestKit
  module USCoreV700
    class SpecifiesCapabilitiesAttestationTest < Inferno::Test
      title 'Specifies capability details'
      id :us_core_v700_att_capability_details
      description %(
        The Health IT Module specifies the full capability details from the US Core CapabilityStatement it claims to implement by
        - Declaring support for the US Core Profile by including its official URL in the server’s
          `CapabilityStatement.rest.resource.supportedProfile` element
        - Declaring support for the US Core Profile’s FHIR RESTful transactions
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@15',
                            'hl7.fhir.us.core_7.0.0@16',
                            'hl7.fhir.us.core_7.0.0@17'

      input :specifies_capability_details,
            title: "Specifies capability details",
            description: %(
              I attest that the Health IT Module specifies the full capability details from the US Core CapabilityStatement it claims
              to implement by
              - Declaring support for the US Core Profile by including its official URL in the server’s
                `CapabilityStatement.rest.resource.supportedProfile` element
              - Declaring support for the US Core Profile’s FHIR RESTful transactions
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                {
                  label: 'Yes',
                  value: 'true'
                },
                {
                  label: 'No',
                  value: 'false'
                }
              ]
            }
      input :specifies_capability_details_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert specifies_capability_details == 'true',
               'Health IT Module did not demonstrate support for specifying capability details.'
        pass specifies_capability_details_note if specifies_capability_details_note.present?
      end
    end
  end
end
