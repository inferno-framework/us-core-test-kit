# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerRoleClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_role_client_support_test
        title 'Support PractitionerRole Resource Access'
        description %(
          
            This test checks whether the client made requests for the PractitionerRole FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-practitioner-role` for the US Core PractitionerRole Profile.
          
        )

        output :practitioner_role_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `PractitionerRole`."
        end

        run do
          practitioner_role_read_requests = load_tagged_requests(READ_PRACTITIONER_ROLE_TAG)
          practitioner_role_search_requests = load_tagged_requests(SEARCH_PRACTITIONER_ROLE_TAG)
          practitioner_role_support = 
            practitioner_role_read_requests.length > 0 ||
            practitioner_role_search_requests.length > 0
          if parent_optional?
            omit_if !practitioner_role_support, skip_message
          else
            skip_if !practitioner_role_support, skip_message
          end

          (output practitioner_role_support:)
        end
      end
    end
  end
end
