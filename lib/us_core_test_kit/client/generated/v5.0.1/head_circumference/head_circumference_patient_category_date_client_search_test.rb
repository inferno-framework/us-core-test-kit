# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class HeadCircumferencePatientCategoryDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_head_circumference_patient_category_date_client_search_test
        title 'SHALL support patient + category + date search of HeadCircumference'
        description %(
          The client demonstrates SHALL support for searching patient + category + date on HeadCircumference.
        )
        optional false

        input :observation_support,
              optional: true

        def required_params
          ["patient", "category", "date"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Observation` resource type, so support for US Core Head Circumference Profile is not expected."
        end

        def failure_message
          "No searches made for the `Observation` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if observation_support.blank?, skip_message
          else
            skip_if observation_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
