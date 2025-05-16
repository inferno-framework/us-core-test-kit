require_relative '../urls'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class RegistrationConfigurationUDAPDisplay < Inferno::Test
        include URLs

        id :us_core_client_v700_reg_config_udap_display
        title 'Confirm client configuration'
        description %(
          This test provides all the information needed for testers to configure
          the client under test to communicate with Inferno's simulated US Core server
          including UDAP endpoints to obtain access tokens.
        )

        input :client_id

        run do
          wait(
            identifier: client_id,
            message: %(
              **Inferno Simulated Server Details**:

              FHIR Base URL: `#{fhir_url}`

              Authentication Details:
              - UDAP Client Id: `#{client_id}`
              - Authorization endpoint: `#{authorization_url}`
              - Token endpoint: `#{token_url}`

              [Click here](#{resume_pass_url}?token=#{client_id}) once you have configured
              the client to connect to Inferno at the above endpoints.
            )
          )
        end
      end
    end
  end
end
