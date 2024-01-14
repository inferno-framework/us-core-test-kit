require_relative '../base_smart_granular_scopes_group'
require_relative '../../generated/v6.1.0/condition_granular_scope1_group'
require_relative '../../generated/v6.1.0/condition_granular_scope2_group'
require_relative '../../generated/v6.1.0/diagnostic_report_granular_scope1_group'
require_relative '../../generated/v6.1.0/diagnostic_report_granular_scope2_group'
require_relative '../../generated/v6.1.0/document_reference_granular_scope1_group'
require_relative '../../generated/v6.1.0/document_reference_granular_scope2_group'
require_relative '../../generated/v6.1.0/observation_granular_scope1_group'
require_relative '../../generated/v6.1.0/observation_granular_scope2_group'
require_relative '../../generated/v6.1.0/service_request_granular_scope1_group'
require_relative '../../generated/v6.1.0/service_request_granular_scope2_group'

module USCoreTestKit
  module USCoreV610
    class SmartGranularScopesGroup < BaseSmartGranularScopesGroup
      id :us_core_v610_smart_granular_scopes
      title 'US Core SMART Granular Scopes'

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

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP1)}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .first
        .group do
          title 'US Core FHIR API w/Granular Scopes 1'

          input :granular_scopes_1_credentials,
                title: 'SMART Credentials for Granular Scopes 1',
                type: :oauth_credentials,
                locked: true

          config(
            inputs: {
              patient_ids: {
                locked: true
              },
              received_scopes: {
                title: 'Received Scopes',
                locked: true
              },
              url: {
                locked: true
              }
            }
          )

          fhir_client do
            oauth_credentials :granular_scopes_1_credentials
            url :url
          end

          group from: :us_core_v610_condition_granular_scope_1_group
          group from: :us_core_v610_diagnostic_report_granular_scope_1_group
          group from: :us_core_v610_document_reference_granular_scope_1_group
          group from: :us_core_v610_observation_granular_scope_1_group
          group from: :us_core_v610_service_request_granular_scope_1_group
      end

      groups
        .last
        .description %(
These tests perform a SMART app launch to receive the following granular scopes:

#{scopes_string(SMART_GRANULAR_SCOPES_GROUP2)}

Then all of the searches which have been performed in the US Core FHIR API tests
are repeated to verify that the results have been filtered according to the
above scopes.
        )

      groups
        .last
        .group do
          title 'US Core FHIR API w/Granular Scopes 2'

          input :granular_scopes_2_credentials,
                title: 'SMART Credentials for Granular Scopes 2',
                type: :oauth_credentials,
                locked: true

          config(
            inputs: {
              patient_ids: {
                locked: true
              },
              received_scopes: {
                title: 'Received Scopes',
                locked: true
              },
              url: {
                locked: true
              }
            }
          )

          fhir_client do
            oauth_credentials :granular_scopes_2_credentials
            url :url
          end

          group from: :us_core_v610_condition_granular_scope_2_group
          group from: :us_core_v610_diagnostic_report_granular_scope_2_group
          group from: :us_core_v610_observation_granular_scope_2_group
          group from: :us_core_v610_service_request_granular_scope_2_group
        end
    end
  end
end
