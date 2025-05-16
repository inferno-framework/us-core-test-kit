# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class SpecimenClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_specimen_client_read_test

        title 'SHALL support read of Specimen'

        description %(
          The client demonstrates SHALL support for reading Specimen.
        )

        def failure_message
          "Did not receive a request for `Specimen` with id: `us-core-client-tests-specimen`."
        end

        run do
          requests = load_tagged_requests(READ_SPECIMEN_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Specimen')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-specimen')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
