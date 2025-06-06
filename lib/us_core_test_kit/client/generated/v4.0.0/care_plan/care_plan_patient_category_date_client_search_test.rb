# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class CarePlanPatientCategoryDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_care_plan_patient_category_date_client_search_test
        title 'SHOULD support patient + category + date search of CarePlan'
        description %(
          The client demonstrates SHOULD support for searching patient + category + date on CarePlan.
        )
        optional true

        input :care_plan_support,
              optional: true

        def required_params
          ["patient", "category", "date"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `CarePlan` resource type, so support for US Core CarePlan Profile is not expected."
        end

        def failure_message
          "No searches made for the `CarePlan` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if care_plan_support.blank?, skip_message
          else
            skip_if care_plan_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_CARE_PLAN_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
