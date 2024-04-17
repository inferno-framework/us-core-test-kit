require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v7.0.0-ballot/capability_statement_group'
require_relative '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative '../../custom_groups/smart_app_launch_group'
require_relative '../../custom_groups/v7.0.0-ballot/smart_granular_scopes_group'
require_relative '../../provenance_validator'
require_relative '../../us_core_options'

require_relative 'patient_group'
require_relative 'allergy_intolerance_group'
require_relative 'care_plan_group'
require_relative 'care_team_group'
require_relative 'condition_encounter_diagnosis_group'
require_relative 'condition_problems_health_concerns_group'
require_relative 'coverage_group'
require_relative 'device_group'
require_relative 'diagnostic_report_note_group'
require_relative 'diagnostic_report_lab_group'
require_relative 'document_reference_group'
require_relative 'encounter_group'
require_relative 'goal_group'
require_relative 'immunization_group'
require_relative 'medication_dispense_group'
require_relative 'medication_request_group'
require_relative 'observation_lab_group'
require_relative 'observation_pregnancystatus_group'
require_relative 'observation_pregnancyintent_group'
require_relative 'observation_occupation_group'
require_relative 'respiratory_rate_group'
require_relative 'simple_observation_group'
require_relative 'treatment_intervention_preference_group'
require_relative 'care_experience_preference_group'
require_relative 'heart_rate_group'
require_relative 'body_temperature_group'
require_relative 'pediatric_weight_for_height_group'
require_relative 'pulse_oximetry_group'
require_relative 'smokingstatus_group'
require_relative 'observation_sexual_orientation_group'
require_relative 'head_circumference_group'
require_relative 'body_height_group'
require_relative 'bmi_group'
require_relative 'observation_screening_assessment_group'
require_relative 'average_blood_pressure_group'
require_relative 'blood_pressure_group'
require_relative 'observation_clinical_result_group'
require_relative 'pediatric_bmi_for_age_group'
require_relative 'head_circumference_percentile_group'
require_relative 'body_weight_group'
require_relative 'procedure_group'
require_relative 'questionnaire_response_group'
require_relative 'service_request_group'
require_relative 'location_group'
require_relative 'organization_group'
require_relative 'practitioner_group'
require_relative 'practitioner_role_group'
require_relative 'provenance_group'
require_relative 'related_person_group'
require_relative 'specimen_group'

module USCoreTestKit
  module USCoreV700_BALLOT
    class USCoreTestSuite < Inferno::TestSuite
      title 'US Core v7.0.0-ballot'
      description %(
        The US Core Test Kit tests systems for their conformance to the [US Core
        Implementation Guide]().

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server. Users should note that the
        although the ONC Certification (g)(10) Standardized API Test Suite
        includes tests from this suite, [it uses a different method to perform
        terminology
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
        /Provenance.agent\[\d*\]: Rule provenance-1/, #Invalid invariant in US Core v5.0.1
        %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this US Core 5 code system in US Core 6 resource
        %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with this US Core 5 code system in US Core 6 resource
        /\A\S+: \S+: URL value '.*' does not resolve/,
        %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      fhir_resource_validator do
        url ENV.fetch('V700_BALLOT_FHIR_RESOURCE_VALIDATOR_URL', 'http://hl7_validator_service:3500')
        igs 'hl7.fhir.us.core#7.0.0-ballot'
        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      id :us_core_v700_ballot

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'

      suite_option :smart_app_launch_version,
        title: 'SMART App Launch Version',
        list_options: [
          {
            label: 'SMART App Launch 1.0.0',
            value: USCoreOptions::SMART_1
          },
          {
            label: 'SMART App Launch 2.0.0',
            value: USCoreOptions::SMART_2
          }
        ]

      group from: :us_core_smart_app_launch

      group do
        input :smart_credentials,
          title: 'OAuth Credentials',
          type: :oauth_credentials,
          optional: true

        fhir_client do
          url :url
          oauth_credentials :smart_credentials
        end

        title 'US Core FHIR API'
        id :us_core_v700_ballot_fhir_api

        config(
          options: {
            tag_requests: true
          }
        )

        group from: :us_core_v700_ballot_capability_statement
      
        group from: :us_core_v700_ballot_patient
        group from: :us_core_v700_ballot_allergy_intolerance
        group from: :us_core_v700_ballot_care_plan
        group from: :us_core_v700_ballot_care_team
        group from: :us_core_v700_ballot_condition_encounter_diagnosis
        group from: :us_core_v700_ballot_condition_problems_health_concerns
        group from: :us_core_v700_ballot_coverage
        group from: :us_core_v700_ballot_device
        group from: :us_core_v700_ballot_diagnostic_report_note
        group from: :us_core_v700_ballot_diagnostic_report_lab
        group from: :us_core_v700_ballot_document_reference
        group from: :us_core_v700_ballot_encounter
        group from: :us_core_v700_ballot_goal
        group from: :us_core_v700_ballot_immunization
        group from: :us_core_v700_ballot_medication_dispense
        group from: :us_core_v700_ballot_medication_request
        group from: :us_core_v700_ballot_observation_lab
        group from: :us_core_v700_ballot_observation_pregnancystatus
        group from: :us_core_v700_ballot_observation_pregnancyintent
        group from: :us_core_v700_ballot_observation_occupation
        group from: :us_core_v700_ballot_respiratory_rate
        group from: :us_core_v700_ballot_simple_observation
        group from: :us_core_v700_ballot_treatment_intervention_preference
        group from: :us_core_v700_ballot_care_experience_preference
        group from: :us_core_v700_ballot_heart_rate
        group from: :us_core_v700_ballot_body_temperature
        group from: :us_core_v700_ballot_pediatric_weight_for_height
        group from: :us_core_v700_ballot_pulse_oximetry
        group from: :us_core_v700_ballot_smokingstatus
        group from: :us_core_v700_ballot_observation_sexual_orientation
        group from: :us_core_v700_ballot_head_circumference
        group from: :us_core_v700_ballot_body_height
        group from: :us_core_v700_ballot_bmi
        group from: :us_core_v700_ballot_observation_screening_assessment
        group from: :us_core_v700_ballot_average_blood_pressure
        group from: :us_core_v700_ballot_blood_pressure
        group from: :us_core_v700_ballot_observation_clinical_result
        group from: :us_core_v700_ballot_pediatric_bmi_for_age
        group from: :us_core_v700_ballot_head_circumference_percentile
        group from: :us_core_v700_ballot_body_weight
        group from: :us_core_v700_ballot_procedure
        group from: :us_core_v700_ballot_questionnaire_response
        group from: :us_core_v700_ballot_service_request
        group from: :us_core_v700_ballot_location
        group from: :us_core_v700_ballot_organization
        group from: :us_core_v700_ballot_practitioner
        group from: :us_core_v700_ballot_practitioner_role
        group from: :us_core_v700_ballot_provenance
        group from: :us_core_v700_ballot_related_person
        group from: :us_core_v700_ballot_specimen
        group from: :us_core_v400_clinical_notes_guidance
        group from: :us_core_311_data_absent_reason
      end

      group from: :us_core_v700_ballot_smart_granular_scopes,
            required_suite_options: USCoreOptions::SMART_2_REQUIREMENT
      
    end
  end
end
