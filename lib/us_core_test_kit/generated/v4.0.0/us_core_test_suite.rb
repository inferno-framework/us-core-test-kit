require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v4.0.0/capability_statement_group'
require_relative '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative '../../custom_groups/smart_app_launch_group'
require_relative '../../provenance_validator'
require_relative '../../us_core_options'

require_relative 'patient_group'
require_relative 'allergy_intolerance_group'
require_relative 'care_plan_group'
require_relative 'care_team_group'
require_relative 'condition_group'
require_relative 'device_group'
require_relative 'diagnostic_report_lab_group'
require_relative 'diagnostic_report_note_group'
require_relative 'document_reference_group'
require_relative 'goal_group'
require_relative 'immunization_group'
require_relative 'medication_request_group'
require_relative 'observation_lab_group'
require_relative 'blood_pressure_group'
require_relative 'bmi_group'
require_relative 'head_circumference_group'
require_relative 'body_height_group'
require_relative 'body_weight_group'
require_relative 'body_temperature_group'
require_relative 'heart_rate_group'
require_relative 'pediatric_bmi_for_age_group'
require_relative 'head_circumference_percentile_group'
require_relative 'pediatric_weight_for_height_group'
require_relative 'pulse_oximetry_group'
require_relative 'respiratory_rate_group'
require_relative 'smokingstatus_group'
require_relative 'procedure_group'
require_relative 'encounter_group'
require_relative 'organization_group'
require_relative 'practitioner_group'
require_relative 'provenance_group'

module USCoreTestKit
  module USCoreV400
    class USCoreTestSuite < Inferno::TestSuite
      title 'US Core Server v4.0.0'
      description %(
        The US Core Server Test Kit tests server systems for their conformance to the [US Core
        Implementation Guide](http://hl7.org/fhir/us/core/STU4).

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

      GENERAL_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v3.1.1
        /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, #Invalid invariant in US Core v5.0.1
        %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this US Core 5 code system in US Core 6 resource
        /\A\S+: \S+: URL value '.*' does not resolve/,
        /\A\S+: \S+: No definition could be found for URL value '.*'/,
        %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'}, # Known issue with the Pulse Oximetry Profile
        %r{Slice 'Observation\.value\[x\]:valueQuantity': a matching slice is required, but not found \(from (http://hl7\.org/fhir/StructureDefinition/bmi\|4\.0\.1|http://hl7\.org/fhir/StructureDefinition/bmi\%7C4\.0\.1)\)}
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      id :us_core_v400

      fhir_resource_validator do
        igs 'hl7.fhir.us.core#4.0.0'
        message_filters = VALIDATION_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'

      suite_option :smart_app_launch_version,
        title: 'SMART App Launch Version',
        default: USCoreOptions::SMART_2,
        list_options: [
          {
            label: 'SMART App Launch 1.0.0',
            value: USCoreOptions::SMART_1
          },
          {
            label: 'SMART App Launch 2.0.0',
            value: USCoreOptions::SMART_2,
          },
          {
            label: 'SMART App Launch 2.2.0',
            value: USCoreOptions::SMART_2_2
          }
        ]

      group from: :us_core_smart_app_launch

      group do
        input :smart_auth_info,
          title: 'OAuth Credentials',
          type: :auth_info,
          optional: true

        fhir_client do
          url :url
          auth_info :smart_auth_info
        end

        title 'US Core FHIR API'
        id :us_core_v400_fhir_api

        group from: :us_core_v400_capability_statement
      
        group from: :us_core_v400_patient
        group from: :us_core_v400_allergy_intolerance
        group from: :us_core_v400_care_plan
        group from: :us_core_v400_care_team
        group from: :us_core_v400_condition
        group from: :us_core_v400_device
        group from: :us_core_v400_diagnostic_report_lab
        group from: :us_core_v400_diagnostic_report_note
        group from: :us_core_v400_document_reference
        group from: :us_core_v400_goal
        group from: :us_core_v400_immunization
        group from: :us_core_v400_medication_request
        group from: :us_core_v400_observation_lab
        group from: :us_core_v400_blood_pressure
        group from: :us_core_v400_bmi
        group from: :us_core_v400_head_circumference
        group from: :us_core_v400_body_height
        group from: :us_core_v400_body_weight
        group from: :us_core_v400_body_temperature
        group from: :us_core_v400_heart_rate
        group from: :us_core_v400_pediatric_bmi_for_age
        group from: :us_core_v400_head_circumference_percentile
        group from: :us_core_v400_pediatric_weight_for_height
        group from: :us_core_v400_pulse_oximetry
        group from: :us_core_v400_respiratory_rate
        group from: :us_core_v400_smokingstatus
        group from: :us_core_v400_procedure
        group from: :us_core_v400_encounter
        group from: :us_core_v400_organization
        group from: :us_core_v400_practitioner
        group from: :us_core_v400_provenance
        group from: :us_core_v400_clinical_notes_guidance
        group from: :us_core_311_data_absent_reason
      end

      links [
        {
          type: 'report_issue',
          label: 'Report Issue',
          url: 'https://github.com/inferno-framework/us-core-test-kit/issues/'
        },
        {
          type: 'source_code',
          label: 'Open Source',
          url: 'https://github.com/inferno-framework/us-core-test-kit/'
        },
        {
          type: 'download',
          label: 'Download', 
          url: 'https://github.com/inferno-framework/us-core-test-kit/releases/'
        }
      ]
    end
  end
end
