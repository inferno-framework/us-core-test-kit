require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v5.0.1/capability_statement_group'
require_relative '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative '../../provenance_validator'
require_relative 'patient_group'
require_relative 'allergy_intolerance_group'
require_relative 'care_plan_group'
require_relative 'care_team_group'
require_relative 'condition_encounter_diagnosis_group'
require_relative 'condition_problems_health_concerns_group'
require_relative 'device_group'
require_relative 'diagnostic_report_note_group'
require_relative 'diagnostic_report_lab_group'
require_relative 'document_reference_group'
require_relative 'encounter_group'
require_relative 'goal_group'
require_relative 'immunization_group'
require_relative 'medication_request_group'
require_relative 'observation_lab_group'
require_relative 'observation_sdoh_assessment_group'
require_relative 'respiratory_rate_group'
require_relative 'observation_social_history_group'
require_relative 'heart_rate_group'
require_relative 'body_temperature_group'
require_relative 'pediatric_weight_for_height_group'
require_relative 'pulse_oximetry_group'
require_relative 'smokingstatus_group'
require_relative 'observation_sexual_orientation_group'
require_relative 'head_circumference_group'
require_relative 'body_height_group'
require_relative 'bmi_group'
require_relative 'blood_pressure_group'
require_relative 'observation_imaging_group'
require_relative 'observation_clinical_test_group'
require_relative 'pediatric_bmi_for_age_group'
require_relative 'head_circumference_percentile_group'
require_relative 'body_weight_group'
require_relative 'procedure_group'
require_relative 'questionnaire_response_group'
require_relative 'service_request_group'
require_relative 'organization_group'
require_relative 'practitioner_group'
require_relative 'provenance_group'
require_relative 'related_person_group'

module USCoreTestKit
  module USCoreV501
    class USCoreTestSuite < Inferno::TestSuite
      title 'US Core v5.0.1'
      description %(
        The US Core Test Kit tests systems for their conformance to the [US Core
        Implementation Guide](http://hl7.org/fhir/us/core/STU5.0.1).

        Resources are validated with the FHIR Java validator using `tx.fhir.org`
        as the terminology server. Users should note that the although the ONC
        Certification (g)(10) Standardized API Test Suite includes tests from
        this suite, [it uses a different method to perform terminology
        validation](https://github.com/onc-healthit/onc-certification-g10-test-kit/wiki/FAQ#q-why-do-some-resources-fail-in-us-core-test-kit-with-terminology-validation-errors).
        As a result, resource validation results may not be consistent between
        the US Core Test Suite and the ONC Certification (g)(10) Standardized
        API Test Suite.
      )
      version VERSION

      VALIDATION_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v3.1.1
        /Provenance.agent\[\d*\]: Rule provenance-1/ #Invalid invariant in US Core v5.0.1
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [/http:\/\/hl7.org\/fhir\/us\/core\/StructureDefinition\/us-core-genderIdentity/].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      validator do
        url ENV.fetch('V501_VALIDATOR_URL', 'http://validator_service:4567')
        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      id :us_core_v501

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

      group from: :us_core_v501_capability_statement
  
      group from: :us_core_v501_patient
      group from: :us_core_v501_allergy_intolerance
      group from: :us_core_v501_care_plan
      group from: :us_core_v501_care_team
      group from: :us_core_v501_condition_encounter_diagnosis
      group from: :us_core_v501_condition_problems_health_concerns
      group from: :us_core_v501_device
      group from: :us_core_v501_diagnostic_report_note
      group from: :us_core_v501_diagnostic_report_lab
      group from: :us_core_v501_document_reference
      group from: :us_core_v501_encounter
      group from: :us_core_v501_goal
      group from: :us_core_v501_immunization
      group from: :us_core_v501_medication_request
      group from: :us_core_v501_observation_lab
      group from: :us_core_v501_observation_sdoh_assessment
      group from: :us_core_v501_respiratory_rate
      group from: :us_core_v501_observation_social_history
      group from: :us_core_v501_heart_rate
      group from: :us_core_v501_body_temperature
      group from: :us_core_v501_pediatric_weight_for_height
      group from: :us_core_v501_pulse_oximetry
      group from: :us_core_v501_smokingstatus
      group from: :us_core_v501_observation_sexual_orientation
      group from: :us_core_v501_head_circumference
      group from: :us_core_v501_body_height
      group from: :us_core_v501_bmi
      group from: :us_core_v501_blood_pressure
      group from: :us_core_v501_observation_imaging
      group from: :us_core_v501_observation_clinical_test
      group from: :us_core_v501_pediatric_bmi_for_age
      group from: :us_core_v501_head_circumference_percentile
      group from: :us_core_v501_body_weight
      group from: :us_core_v501_procedure
      group from: :us_core_v501_questionnaire_response
      group from: :us_core_v501_service_request
      group from: :us_core_v501_organization
      group from: :us_core_v501_practitioner
      group from: :us_core_v501_provenance
      group from: :us_core_v501_related_person
      group from: :us_core_v400_clinical_notes_guidance
      group from: :us_core_311_data_absent_reason
    end
  end
end
