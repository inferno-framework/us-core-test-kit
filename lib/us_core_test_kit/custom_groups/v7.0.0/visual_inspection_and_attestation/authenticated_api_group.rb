require_relative 'authenticated_api_security'
require_relative 'authenticated_api_security2'

module USCoreTestKit
  module USCoreV700
    class FormularyAuthenticatedApiSecurityGroup < Inferno::TestGroup
      id :us_core_v700_security_group
      title 'Security Group'

      description <<~DESCRIPTION
        Security Group
      DESCRIPTION

      run_as_group

      test from: :Test01
      test from: :Test02
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