# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      RESUME_PASS_ROUTE = '/resume_pass'
      FHIR_ROUTE = '/fhir'
      READ_ROUTE = "#{FHIR_ROUTE}/:resource_type/:resource_id"
      SEARCH_ROUTE = "#{FHIR_ROUTE}/:resource_type"

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

        def read_url
          base_url + READ_ROUTE
        end

        def search_url
          base_url + SEARCH_ROUTE
        end

        def suite_id
          'us_core_client_v610'
        end
      end
    end
  end
end
