require 'inferno'
require 'smart_app_launch_test_kit'
require_relative './smart_ehr_launch_stu2'
require_relative './smart_scopes_constants'
require_relative './smart_standalone_launch_stu2_group'
require_relative '../granular_scope_checker'
require_relative '../us_core_options'

module USCoreTestKit
  class BaseSmartGranularScopesGroup < Inferno::TestGroup
    id :us_core_base_smart_granular_scopes
    title 'US Core SMART Granular Scopes'

    include SmartScopesConstants

    description <<~DESCRIPTION
      These tests verify that servers honor [SMART App Launch granular
      scopes](http://hl7.org/fhir/smart-app-launch/STU2/scopes-and-launch-context.html#finer-grained-resource-constraints-using-search-parameters).
      Support for these scopes is [required in US Core
      7](http://hl7.org/fhir/us/core/2024Jan/scopes.html#us-core-scopes).

      Prior to running these tests, first run the US Core FHIR API tests using
      resource-level scopes. This group contains two sets of granular scope
      tests, each of which includes a SMART App Launch followed by FHIR API
      tests. The app launches require that a particular subset of the required
      granular scopes be granted. The FHIR API tests then repeat all of the
      queries from the original FHIR API tests that were run using
      resource-level scopes, and verify that only resources matching the current
      granular scopes are returned.
    DESCRIPTION

    group do
      title 'Granular Scopes 1'

      def self.default_group_scopes
        [DEFAULT_SCOPES, *SMART_GRANULAR_SCOPES_GROUP1].join(' ')
      end

      config(
        inputs: {
          requested_scopes: {
            name: :requested_scopes_group1,
            default: default_group_scopes
          },
          url: {
            locked: true
          }
        }
      )

      group do
        title 'SMART App Launch w/Granular Scopes 1'

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
              }
        group from: :us_core_smart_ehr_launch_stu2,
              optional: true,
              config: {
                inputs: {
                  smart_credentials: {
                    name: :granular_scopes_1_credentials
                  }
                }
              }

        # TODO: verify that all required scopes were requested and received
      end
    end

    group do
      title 'Granular Scopes 2'

      def self.default_group_scopes
        [DEFAULT_SCOPES, *SMART_GRANULAR_SCOPES_GROUP2].join(' ')
      end

      config(
        inputs: {
          requested_scopes: {
            name: :requested_scopes_group2,
            default: default_group_scopes
          }
        }
      )

      group do
        title 'SMART App Launch w/Granular Scopes 2'

        config(
          outputs: {
            smart_credentials: {
              name: :granular_scopes_2_credentials
            }
          }
        )

        group from: :us_core_smart_standalone_launch_stu2,
              optional: true,
              config: {
                inputs: {
                  smart_credentials: {
                    name: :granular_scopes_2_credentials
                  }
                }
              }


        group from: :us_core_smart_ehr_launch_stu2,
              optional: true,
              config: {
                inputs: {
                  smart_credentials: {
                    name: :granular_scopes_2_credentials
                  }
                }
              }


        # TODO: verify that all required scopes were requested and received
      end
    end
  end
end
