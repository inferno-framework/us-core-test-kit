# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class SpecimenClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_specimen_client_read_test
        title 'SHALL support read of Specimen'
        description %(
          The client demonstrates SHALL support for reading Specimen.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Specimen` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Specimen Profile: `Specimen/us-core-client-tests-specimen`."
        end

        run do
          requests = load_tagged_requests(READ_SPECIMEN_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-specimen')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
