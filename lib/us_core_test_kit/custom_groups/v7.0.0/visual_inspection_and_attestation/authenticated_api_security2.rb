module USCoreTestKit
  module USCoreV700
    class FormularyAuthenticatedApiSecurityTest2 < Inferno::Test
      title 'Health IT Module demonstrated support for application registration for single patients.'
      description %(
        Health IT Module demonstrated support for application registration for
        single patients.
      )
      id :Test02
      input :single_patient_registration_supported2,
            title: '2: Health IT Module demonstrated support for application registration for single patients.',
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
      input :single_patient_registration_notes2,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert single_patient_registration_supported == 'true',
               'Health IT Module did not demonstrate support for application registration for single patients.'
        pass single_patient_registration_notes if single_patient_registration_notes.present?
      end
    end
  end
end



    # config(
    #   inputs: {
    #     smart_auth_info: {
    #       name: :standalone_smart_auth_info,
    #       title: 'Standalone Launch Credentials',
    #       options: {
    #         components: [
    #           {
    #             name: :requested_scopes,
    #             default: 'launch/patient openid fhirUser offline_access patient/*.rs'
    #           },
    #           {
    #             name: :pkce_support,
    #             default: 'enabled',
    #             locked: true
    #           },
    #           {
    #             name: :pkce_code_challenge_method,
    #             default: 'S256',
    #             locked: true
    #           },
    #           Inferno::DSL::AuthInfo.default_auth_type_component_without_backend_services,
    #           {
    #             name: :use_discovery,
    #             locked: true
    #           }
    #         ]
    #       }
    #     }
    #   }
    # )