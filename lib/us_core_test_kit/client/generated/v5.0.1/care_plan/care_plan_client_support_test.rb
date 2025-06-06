# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class CarePlanClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v501_care_plan_client_support_test
        title 'Support CarePlan Resource Access'
        description %(
          
            This test checks whether the client made requests for the CarePlan FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-care-plan` for the US Core CarePlan Profile.
          
        )

        output :care_plan_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `CarePlan`."
        end

        run do
          care_plan_read_requests = load_tagged_requests(READ_CARE_PLAN_TAG)
          care_plan_search_requests = load_tagged_requests(SEARCH_CARE_PLAN_TAG)
          care_plan_support = 
            care_plan_read_requests.length > 0 ||
            care_plan_search_requests.length > 0
          if parent_optional?
            omit_if !care_plan_support, skip_message
          else
            skip_if !care_plan_support, skip_message
          end

          (output care_plan_support:)
        end
      end
    end
  end
end
