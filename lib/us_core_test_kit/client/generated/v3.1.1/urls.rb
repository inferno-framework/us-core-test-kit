# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      RESUME_PASS_ROUTE = '/resume_pass'
      FHIR_ROUTE = '/fhir'
      READ_ROUTE = "#{FHIR_ROUTE}/:resource_type/:resource_id"
      SEARCH_ROUTE = "#{FHIR_ROUTE}/:resource_type"
      SEARCH_POST_ROUTE = "#{FHIR_ROUTE}/:resource_type/_search"
      METADATA_PATH = "#{FHIR_ROUTE}/metadata"
      TOKEN_PATH = '/auth/token'.freeze
      AUTHORIZATION_PATH = '/auth/authorization'.freeze

      module URLs
        def base_url
          "#{Inferno::Application['base_url']}/custom/#{suite_id}"
        end

        def resume_pass_url
          base_url + RESUME_PASS_ROUTE
        end

        def fhir_url
          base_url + FHIR_ROUTE
        end

        def client_fhir_base_url # alias for OIDC from SMART client tests
          fhir_url
        end

        def read_url
          base_url + READ_ROUTE
        end

        def search_url
          base_url + SEARCH_ROUTE
        end

        def token_url
          @token_url ||= base_url + TOKEN_PATH
        end

        def authorization_url
          @authorization_url ||= base_url + AUTHORIZATION_PATH
        end

        def suite_id
          'us_core_client_v311'
        end
      end
    end
  end
end
