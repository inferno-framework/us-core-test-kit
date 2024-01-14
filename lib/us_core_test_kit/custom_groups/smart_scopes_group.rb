require 'inferno'
require 'smart_app_launch_test_kit'
require_relative '../granular_scope_checker'
require_relative './smart_scopes_constants'
require_relative '../us_core_options'
require_relative '../custom_groups/smart_ehr_launch_stu2'
require_relative '../custom_groups/smart_standalone_launch_stu2_group'
require_relative '../generated/v6.1.0/condition_granular_scope1_group'
require_relative '../generated/v6.1.0/condition_granular_scope2_group'
require_relative '../generated/v6.1.0/diagnostic_report_granular_scope1_group'
require_relative '../generated/v6.1.0/diagnostic_report_granular_scope2_group'
require_relative '../generated/v6.1.0/document_reference_granular_scope1_group'
require_relative '../generated/v6.1.0/document_reference_granular_scope2_group'
require_relative '../generated/v6.1.0/observation_granular_scope1_group'
require_relative '../generated/v6.1.0/observation_granular_scope2_group'
require_relative '../generated/v6.1.0/service_request_granular_scope1_group'
require_relative '../generated/v6.1.0/service_request_granular_scope2_group'
require_relative '../generated/v7.0.0-ballot/condition_granular_scope1_group'
require_relative '../generated/v7.0.0-ballot/condition_granular_scope2_group'
require_relative '../generated/v7.0.0-ballot/diagnostic_report_granular_scope1_group'
require_relative '../generated/v7.0.0-ballot/diagnostic_report_granular_scope2_group'
require_relative '../generated/v7.0.0-ballot/document_reference_granular_scope1_group'
require_relative '../generated/v7.0.0-ballot/document_reference_granular_scope2_group'
require_relative '../generated/v7.0.0-ballot/observation_granular_scope1_group'
require_relative '../generated/v7.0.0-ballot/observation_granular_scope2_group'
require_relative '../generated/v7.0.0-ballot/service_request_granular_scope1_group'
require_relative '../generated/v7.0.0-ballot/service_request_granular_scope2_group'

module USCoreTestKit
  class SmartScopesGroup < Inferno::TestGroup
    id :us_core_smart_scopes
    title 'US Core SMART Scopes'

    include SmartScopesConstants

    group do
      title 'Granular Scopes 1'

      def self.default_group_scopes
        [SmartScopesGroup::DEFAULT_SCOPES, *SmartScopesGroup::SMART_GRANULAR_SCOPES_GROUP1].join(' ')
      end

      config(
        inputs: {
          requested_scopes: {
            name: :requested_scopes_group1,
            default: default_group_scopes
          }
        }
      )

      group do
        title 'SMART App Launch w/Granular Scopes 1'

        group from: :us_core_smart_standalone_launch_stu2,
              optional: true

        group from: :us_core_smart_ehr_launch_stu2,
              optional: true

        # TODO: verify that all required scopes were requested and received
      end

      group do
        title 'US Core FHIR API w/Granular Scopes 1'

        group from: :us_core_v610_condition_granular_scope_1_group
        group from: :us_core_v610_diagnostic_report_granular_scope_1_group
        group from: :us_core_v610_document_reference_granular_scope_1_group
        group from: :us_core_v610_observation_granular_scope_1_group
        group from: :us_core_v610_service_request_granular_scope_1_group
      end
    end

    group do
      title 'Granular Scopes 2'

      def self.default_group_scopes
        [SmartScopesGroup::DEFAULT_SCOPES, *SmartScopesGroup::SMART_GRANULAR_SCOPES_GROUP2].join(' ')
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

        group from: :us_core_smart_standalone_launch_stu2,
              optional: true

        group from: :us_core_smart_ehr_launch_stu2,
              optional: true

        # TODO: verify that all required scopes were requested and received
      end

      group do
        title 'US Core FHIR API w/Granular Scopes 2'

        group from: :us_core_v610_condition_granular_scope_2_group
        group from: :us_core_v610_diagnostic_report_granular_scope_2_group
        group from: :us_core_v610_document_reference_granular_scope_2_group
        group from: :us_core_v610_observation_granular_scope_2_group
        group from: :us_core_v610_service_request_granular_scope_2_group
      end
    end
  end
end
