# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DocumentReferencePatientTypeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_document_reference_patient_type_client_search_test

        title 'SHALL support patient + type search of DocumentReference'

        description %(
          The client demonstrates SHALL support for searching patient + type on DocumentReference.
        )

        def required_params
          ["patient", "type"]
        end

        def failure_message
          "Did not receive a request for `DocumentReference` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_DOCUMENT_REFERENCE_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'DocumentReference')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
