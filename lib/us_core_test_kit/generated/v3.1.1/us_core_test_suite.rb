require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/capability_statement_group'
require_relative '../../custom_groups/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative 'patient_group'
require_relative 'allergy_intolerance_group'
require_relative 'care_plan_group'
require_relative 'care_team_group'
require_relative 'condition_group'
require_relative 'device_group'
require_relative 'diagnostic_report_note_group'
require_relative 'diagnostic_report_lab_group'
require_relative 'document_reference_group'
require_relative 'goal_group'
require_relative 'immunization_group'
require_relative 'medication_request_group'
require_relative 'smokingstatus_group'
require_relative 'pediatric_weight_for_height_group'
require_relative 'observation_lab_group'
require_relative 'pediatric_bmi_for_age_group'
require_relative 'pulse_oximetry_group'
require_relative 'head_circumference_percentile_group'
require_relative 'bodyheight_group'
require_relative 'bodytemp_group'
require_relative 'bp_group'
require_relative 'bodyweight_group'
require_relative 'heartrate_group'
require_relative 'resprate_group'
require_relative 'procedure_group'
require_relative 'encounter_group'
require_relative 'organization_group'
require_relative 'practitioner_group'
require_relative 'provenance_group'

module USCoreTestKit
  module USCoreV311
    class USCoreTestSuite < Inferno::TestSuite
      title 'US Core v3.1.1'
      version VERSION

      VALIDATION_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris$},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris$},
        /^Observation\.effective\.ofType\(Period\): vs-1:/, # Invalid invariant in FHIR v4.0.1
        /^Observation\.effective\.ofType\(Period\): us-core-1:/ # Invalid invariant in US Core v3.1.1
      ].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'))[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      validator do
        url ENV.fetch('V311_VALIDATOR_URL', 'http://validator_service:4567')
        exclude_message do |message|
          VALIDATION_MESSAGE_FILTERS.any? { |filter| filter.match? message.message }
        end
      end

      id :us_core_v311

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'
      input :smart_credentials,
        title: 'OAuth Credentials',
        type: :oauth_credentials,
        optional: true

      fhir_client do
        url :url
        oauth_credentials :smart_credentials
      end

      group from: :us_core_311_capability_statement
  
      group from: :us_core_v311_patient
      group from: :us_core_v311_allergy_intolerance
      group from: :us_core_v311_care_plan
      group from: :us_core_v311_care_team
      group from: :us_core_v311_condition
      group from: :us_core_v311_device
      group from: :us_core_v311_diagnostic_report_note
      group from: :us_core_v311_diagnostic_report_lab
      group from: :us_core_v311_document_reference
      group from: :us_core_v311_goal
      group from: :us_core_v311_immunization
      group from: :us_core_v311_medication_request
      group from: :us_core_v311_smokingstatus
      group from: :us_core_v311_pediatric_weight_for_height
      group from: :us_core_v311_observation_lab
      group from: :us_core_v311_pediatric_bmi_for_age
      group from: :us_core_v311_pulse_oximetry
      group from: :us_core_v311_head_circumference_percentile
      group from: :us_core_v311_bodyheight
      group from: :us_core_v311_bodytemp
      group from: :us_core_v311_bp
      group from: :us_core_v311_bodyweight
      group from: :us_core_v311_heartrate
      group from: :us_core_v311_resprate
      group from: :us_core_v311_procedure
      group from: :us_core_v311_encounter
      group from: :us_core_v311_organization
      group from: :us_core_v311_practitioner
      group from: :us_core_v311_provenance
      group from: :us_core_311_clinical_notes_guidance
      group from: :us_core_311_data_absent_reason
    end
  end
end
