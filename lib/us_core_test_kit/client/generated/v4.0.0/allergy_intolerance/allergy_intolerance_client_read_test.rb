# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class AllergyIntoleranceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_allergy_intolerance_client_read_test
        title 'SHALL support read of AllergyIntolerance'
        description %(
          The client demonstrates SHALL support for reading AllergyIntolerance.
        )

        input :allergy_intolerance_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `AllergyIntolerance` resource type, so support for US Core AllergyIntolerance Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core AllergyIntolerance Profile: `AllergyIntolerance/us-core-client-tests-allergy-intolerance`."
        end

        run do
          if parent_optional?
            omit_if allergy_intolerance_support.blank?, skip_message
          else
            skip_if allergy_intolerance_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_ALLERGY_INTOLERANCE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-allergy-intolerance')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
