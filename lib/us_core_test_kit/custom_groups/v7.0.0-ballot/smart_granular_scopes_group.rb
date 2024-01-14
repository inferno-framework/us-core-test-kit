require_relative '../base_smart_granular_scopes_group'
require_relative '../../generated/v7.0.0-ballot/condition_granular_scope1_group'
require_relative '../../generated/v7.0.0-ballot/condition_granular_scope2_group'
require_relative '../../generated/v7.0.0-ballot/diagnostic_report_granular_scope1_group'
require_relative '../../generated/v7.0.0-ballot/diagnostic_report_granular_scope2_group'
require_relative '../../generated/v7.0.0-ballot/document_reference_granular_scope1_group'
require_relative '../../generated/v7.0.0-ballot/document_reference_granular_scope2_group'
require_relative '../../generated/v7.0.0-ballot/observation_granular_scope1_group'
require_relative '../../generated/v7.0.0-ballot/observation_granular_scope2_group'
require_relative '../../generated/v7.0.0-ballot/service_request_granular_scope1_group'
require_relative '../../generated/v7.0.0-ballot/service_request_granular_scope2_group'

module USCoreTestKit
  module USCoreV610
    class SmartGranularScopesGroup < BaseSmartGranularScopesGroup
      id :us_core_v700_ballot_smart_granular_scopes
      title 'US Core SMART Granular Scopes'

      groups
        .first
        .group do
          title 'US Core FHIR API w/Granular Scopes 1'

          input :granular_scopes_1_credentials,
                title: 'SMART Credentials for Granular Scopes 1',
                type: :oauth_credentials,
                locked: true

          fhir_client do
            oauth_credentials :granular_scopes_1_credentials
            url :url
          end

          group from: :us_core_v700_ballot_condition_granular_scope_1_group
          group from: :us_core_v700_ballot_diagnostic_report_granular_scope_1_group
          group from: :us_core_v700_ballot_document_reference_granular_scope_1_group
          group from: :us_core_v700_ballot_observation_granular_scope_1_group
          group from: :us_core_v700_ballot_service_request_granular_scope_1_group
        end

      groups
        .last
        .group do
          title 'US Core FHIR API w/Granular Scopes 2'

          input :granular_scopes_2_credentials,
                title: 'SMART Credentials for Granular Scopes 2',
                type: :oauth_credentials,
                locked: true

          fhir_client do
            oauth_credentials :granular_scopes_2_credentials
            url :url
          end

          group from: :us_core_v700_ballot_condition_granular_scope_2_group
          group from: :us_core_v700_ballot_diagnostic_report_granular_scope_2_group
          group from: :us_core_v700_ballot_observation_granular_scope_2_group
          group from: :us_core_v700_ballot_service_request_granular_scope_2_group
        end
    end
  end
end
