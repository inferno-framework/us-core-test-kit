require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v3.1.1/capability_statement_group'
require_relative '../../custom_groups/v3.1.1/clinical_notes_guidance_group'
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
require_relative 'head_circumference_group'
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
      description %(
        The US Core Test Kit tests systems for their conformance to the [US Core
        Implementation Guide](http://hl7.org/fhir/us/core/STU3.1.1).

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
        %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      validator do
        url ENV.fetch('V311_VALIDATOR_URL', 'http://validator_service:4567')
        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      id :us_core_v311

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
        id :us_core_v311_fhir_api

        group from: :us_core_v311_capability_statement
      
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
        group from: :us_core_v311_head_circumference
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
        group from: :us_core_v311_clinical_notes_guidance
        group from: :us_core_311_data_absent_reason
      end
    end
  end
end
