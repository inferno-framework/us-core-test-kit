# frozen_string_literal: true

require_relative 'related_person/related_person_client_read_test'
require_relative 'related_person/related_person_id_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class RelatedPersonClientGroup < Inferno::TestGroup
        id :us_core_client_v501_related_person

        title 'RelatedPerson'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required RelatedPerson queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-related-person`

## Searching
This sequence will check that the client performed searches with the following parameters:

* _id

        )

        run_as_group

        test from: :us_core_v501_related_person_client_read_test
        test from: :us_core_v501_related_person_id_client_search_test
      end
    end
  end
end
