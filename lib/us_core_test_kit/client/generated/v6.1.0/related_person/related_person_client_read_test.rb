# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class RelatedPersonClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_related_person_client_read_test
        title 'SHALL support read of RelatedPerson'
        description %(
          The client demonstrates SHALL support for reading RelatedPerson.
        )

        input :related_person_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `RelatedPerson` resource type, so support for US Core RelatedPerson Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core RelatedPerson Profile: `RelatedPerson/us-core-client-tests-related-person`."
        end

        run do
          if parent_optional?
            omit_if related_person_support.blank?, skip_message
          else
            skip_if related_person_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_RELATED_PERSON_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-related-person')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
