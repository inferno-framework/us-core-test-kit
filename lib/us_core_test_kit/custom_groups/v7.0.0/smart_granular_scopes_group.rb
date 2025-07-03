require_relative '../base_smart_granular_scopes_group'
require_relative '../../generated/v7.0.0/granular_scopes1_group'
require_relative '../../generated/v7.0.0/granular_scopes2_group'

module USCoreTestKit
  module USCoreV700
    class SmartGranularScopesGroup < BaseSmartGranularScopesGroup
      id :us_core_v700_smart_granular_scopes
      title 'US Core SMART Granular Scopes'

      verifies_requirements 'hl7.fhir.us.core_7.0.0@158',
                            'hl7.fhir.us.core_7.0.0@159',
                            'hl7.fhir.us.core_7.0.0@160',
                            'hl7.fhir.us.core_7.0.0@161',
                            'hl7.fhir.us.core_7.0.0@162',
                            'hl7.fhir.us.core_7.0.0@163',
                            'hl7.fhir.us.core_7.0.0@164',
                            'hl7.fhir.us.core_7.0.0@165'

      def self.scopes_string(scopes)
        scopes
          .map { |scope| scope.delete_prefix 'patient/' }
          .map { |scope| "* `#{scope}`" }
          .join("\n")
      end

      groups
        .first
        .description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP1['v700'])}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .first
        .config(
          inputs: {
            smart_auth_info: {
              name: :granular_scopes_1_auth_info,
              title: 'Granular Scopes 1 Credentials',
              options: {
                components: [
                  {
                    name: :requested_scopes,
                    default: groups.first.default_group_scopes('v700')
                  }
                ]
              }
            }
          },
          options: {
            required_scopes: SMART_GRANULAR_SCOPES_GROUP1['v700']
          }
        )

      groups
        .first
        .group from: :us_core_v700_smart_granular_scopes_1

      groups
        .last
        .description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP2['v700'])}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .last
        .config(
          inputs: {
            smart_auth_info: {
              name: :granular_scopes_2_auth_info,
              title: 'Granular Scopes 2 Credentials',
              options: {
                components: [
                  {
                    name: :requested_scopes,
                    default: groups.last.default_group_scopes('v700')
                  }
                ]
              }
            }
          },
          options: {
            required_scopes: SMART_GRANULAR_SCOPES_GROUP2['v700']
          }
        )

      groups
        .last
        .group from: :us_core_v700_smart_granular_scopes_2
    end
  end
end