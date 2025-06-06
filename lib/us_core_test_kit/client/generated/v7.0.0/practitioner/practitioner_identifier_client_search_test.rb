# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerIdentifierClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_practitioner_identifier_client_search_test
        title 'SHALL support identifier search of Practitioner'
        description %(
          The client demonstrates SHALL support for searching identifier on Practitioner.
        )
        optional false

        input :practitioner_support,
              optional: true

        def required_params
          ["identifier"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Practitioner` resource type, so support for US Core Practitioner Profile is not expected."
        end

        def failure_message
          "No searches made for the `Practitioner` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if practitioner_support.blank?, skip_message
          else
            skip_if practitioner_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_PRACTITIONER_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
