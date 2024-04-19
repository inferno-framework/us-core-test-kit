require_relative '../base_smart_granular_scopes_group'
require_relative '../smart_scopes_constants'
require_relative '../granted_granular_scopes_test'
require_relative '../../generated/v6.1.0/granular_scopes1_group'

module USCoreTestKit
  module USCoreV610
    class SmartGranularScopesGroup < Inferno::TestGroup
      include SmartScopesConstants
      title 'US Core SMART Granular Scopes'
      id :us_core_v610_smart_granular_scopes

      description <<~DESCRIPTION
        These tests verify that servers honor [SMART App Launch granular
        scopes](http://hl7.org/fhir/smart-app-launch/STU2/scopes-and-launch-context.html#finer-grained-resource-constraints-using-search-parameters).
        Support for these scopes is [required in US Core
        7](http://hl7.org/fhir/us/core/2024Jan/scopes.html#us-core-scopes).

        Prior to running these tests, first run the US Core FHIR API tests using
        resource-level scopes. This group includes a SMART App Launch followed by
        FHIR API tests. The app launches require that a granular scopes be
        granted. The FHIR API tests then repeat all of the queries from the
        original FHIR API tests that were run using resource-level scopes, and
        verify that only resources matching the granted granular scopes are
        returned.
      DESCRIPTION

      def self.default_group_scopes(version)
        [DEFAULT_SCOPES, *SMART_GRANULAR_SCOPES_GROUP1[version]].join(' ')
      end

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
          },
          requested_scopes: {
            name: :requested_scopes_group1,
            default: default_group_scopes('v610')
          }
        }
      )

      group do
        title 'SMART App Launch w/Granular Scopes'

        def self.scopes_string(scopes)
          scopes
            .map { |scope| scope.delete_prefix 'patient/' }
            .map { |scope| "* `#{scope}`" }
            .join("\n")
        end

        description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP1['v610'])}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

        config(
          outputs: {
            smart_credentials: {
              name: :granular_scopes_1_credentials
            }
          }
        )
        group from: :us_core_smart_standalone_launch_stu2,
              optional: true,
              config: {
                inputs: {
                  smart_credentials: {
                    name: :granular_scopes_1_credentials
                  }
                }
              } do
          groups[1].test from: :us_core_granted_granular_scopes,
                         config: {
                           inputs: {
                             received_scopes: {
                               name: :standalone_received_scopes
                             }
                           },
                           options: {
                             required_scopes: SMART_GRANULAR_SCOPES_GROUP1['v610']
                           }
                         }
        end
        group from: :us_core_smart_ehr_launch_stu2,
              optional: true,
              config: {
                inputs: {
                  smart_credentials: {
                    name: :granular_scopes_1_credentials
                  }
                }
              } do
          groups[1].test from: :us_core_granted_granular_scopes,
                         config: {
                           inputs: {
                             received_scopes: {
                               name: :ehr_received_scopes
                             }
                           },
                           options: {
                             required_scopes: SMART_GRANULAR_SCOPES_GROUP1['v610']
                           }
                         }
        end
      end

      group from: :us_core_v610_smart_granular_scopes_1,
            title: 'US Core FHIR API w/Granular Scopes'
    end
  end
end
