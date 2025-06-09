# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class RelatedPersonClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_related_person_client_read_test
        title 'SHALL support read of RelatedPerson'
        description %(
          The client demonstrates SHALL support for reading RelatedPerson.
        )

        def skip_message
          "Inferno did not receive any read requests for the `RelatedPerson` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core RelatedPerson Profile: `RelatedPerson/us-core-client-tests-related-person`."
        end

        run do
          requests = load_tagged_requests(READ_RELATED_PERSON_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-related-person')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
