# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DocumentReferencePatientCategoryClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_document_reference_patient_category_client_search_test
        title 'SHALL support patient + category search of DocumentReference'
        description %(
          The client demonstrates SHALL support for searching patient + category on DocumentReference.
        )
        optional false

        def required_params
          ["patient", "category"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `DocumentReference` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `DocumentReference` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_DOCUMENT_REFERENCE_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
