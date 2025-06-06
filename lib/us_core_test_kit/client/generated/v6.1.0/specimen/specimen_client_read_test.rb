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

        input :specimen_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Specimen` resource type, so support for US Core Specimen Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Specimen Profile: `Specimen/us-core-client-tests-specimen`."
        end

        run do
          if parent_optional?
            omit_if specimen_support.blank?, skip_message
          else
            skip_if specimen_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_SPECIMEN_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-specimen')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
