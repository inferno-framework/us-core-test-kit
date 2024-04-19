require_relative '../base_smart_granular_scopes_group'
require_relative '../../generated/v7.0.0-ballot/granular_scopes1_group'
require_relative '../../generated/v7.0.0-ballot/granular_scopes2_group'

module USCoreTestKit
  module USCoreV700_BALLOT
    class SmartGranularScopesGroup < BaseSmartGranularScopesGroup
      id :us_core_v700_ballot_smart_granular_scopes
      title 'US Core SMART Granular Scopes'

      def self.scopes_string(scopes)
        scopes
          .map { |scope| scope.delete_prefix 'patient/' }
          .map { |scope| "* `#{scope}`" }
          .join("\n")
      end

      config(
        inputs: {
          url: {
            locked: true
          }
        }
      )

      groups
        .first
        .description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP1['v700_ballot'])}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .first
        .config(
          inputs: {
            requested_scopes: {
              name: :requested_scopes_group1,
              default: groups.first.default_group_scopes('v700_ballot')
            }
          },
          options: {
            required_scopes: SMART_GRANULAR_SCOPES_GROUP1['v700_ballot']
          }
        )

      groups
        .first
        .group from: :us_core_v700_ballot_smart_granular_scopes_1

      groups
        .last
        .description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP2['v700_ballot'])}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .last
        .config(
          inputs: {
            requested_scopes: {
              name: :requested_scopes_group2,
              default: groups.last.default_group_scopes('v700_ballot')
            }
          },
          options: {
            required_scopes: SMART_GRANULAR_SCOPES_GROUP2['v700_ballot']
          }
        )

      groups
        .last
        .group from: :us_core_v700_ballot_smart_granular_scopes_2
    end
  end
end
