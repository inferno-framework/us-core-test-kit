# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class SpecimenIdClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_specimen_id_client_search_test
        title 'SHALL support _id search of Specimen'
        description %(
          The client demonstrates SHALL support for searching _id on Specimen.
        )
        optional false

        input :specimen_support,
              optional: true

        def required_params
          ["_id"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Specimen` resource type, so support for US Core Specimen Profile is not expected."
        end

        def failure_message
          "No searches made for the `Specimen` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if specimen_support.blank?, skip_message
          else
            skip_if specimen_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_SPECIMEN_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
