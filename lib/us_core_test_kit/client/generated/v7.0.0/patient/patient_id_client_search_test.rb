# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PatientIdClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_patient_id_client_search_test
        title 'SHALL support _id search of Patient'
        description %(
          The client demonstrates SHALL support for searching _id on Patient.
        )
        optional false

        input :patient_support,
              optional: true

        def required_params
          ["_id"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Patient` resource type, so support for US Core Patient Profile is not expected."
        end

        def failure_message
          "No searches made for the `Patient` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if patient_support.blank?, skip_message
          else
            skip_if patient_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_PATIENT_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
