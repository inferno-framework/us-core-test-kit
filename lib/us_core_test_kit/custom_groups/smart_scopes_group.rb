require 'smart_app_launch_test_kit'
require_relative '../granular_scope_checker'
require_relative '../us_core_options'
require_relative '../generated/v6.1.0/condition_encounter_diagnosis_group'
require_relative '../generated/v6.1.0/condition_problems_health_concerns_group'

module USCoreTestKit
  class SmartScopesGroup < Inferno::TestGroup
    id :us_core_smart_scopes
    title 'US Core SMART Scopes'

    DEFAULT_SCOPES = 'launch/patient openid fhirUser offline_access'

    SMART_GRANULAR_SCOPES_GROUP1 = [
      'patient.Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis',
      'patient.Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern',
      'patient.DiagnosticReport.rs?category=http://loinc.org|LP29684-5',
      'patient.DiagnosticReport.rs?category=http://loinc.org|LP29708-2',
      'patient.DocumentReference.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category|clinical-note',
      'patient.Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory',
      'patient.Observation.rs?category=http://terminology.hl7.org//CodeSystem-observation-category.html|social-history',
      'patient.Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|imagin',
      'patient.Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|procedure',
      'patient.ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh'
    ].freeze

    SMART_GRANULAR_SCOPES_GROUP2 = [
      'patient.Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item',
      'patient.DiagnosticReport.rs?category=http://loinc.org|LP7839-6',
      'patient.DiagnosticReport.rs?category=http://terminology.hl7.org/CodeSystem/v2-0074|LAB',
      'patient.Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-sign',
      'patient.Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|treatment-intervention-preference',
      'patient.Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|care-experience-preference',
      'patient.ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|functional-status',
      'patient.ServiceRequest.rs?category=http://snomed.info/sct|surgical-procedure'
    ]

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

        # TODO: generate all this
        group from: :us_core_v610_condition_encounter_diagnosis
        group from: :us_core_v610_condition_problems_health_concerns
        # group from: :us_core_v610_diagnostic_report_lab
        # group from: :us_core_v610_diagnostic_report_note
        # group from: :us_core_v610_document_reference
        # group from: :us_core_v610_observation_lab
        # group from: :us_core_v610_observation_occupation
        # group from: :us_core_v610_observation_clinical_result
        # group from: :us_core_v610_observation_pregnancyintent
        # group from: :us_core_v610_observation_pregnancystatus
        # group from: :us_core_v610_observation_sexual_orientation
        # group from: :us_core_v610_observation_screening_assessment
        # group from: :us_core_v610_simple_observation
        # # TODO: add other observation groups
        # group from: :us_core_v610_service_request

        groups.each do |group|
          group.children.select! { |test| test.id.to_s.end_with? 'search_test' }
          group.tests.each { |test| test.include GranularScopeChecker }
        end
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

        # TODO: generate all this
        group from: :us_core_v610_condition_encounter_diagnosis
        group from: :us_core_v610_condition_problems_health_concerns
        # group from: :us_core_v610_diagnostic_report_lab
        # group from: :us_core_v610_diagnostic_report_note
        # group from: :us_core_v610_document_reference
        # group from: :us_core_v610_observation_lab
        # group from: :us_core_v610_observation_occupation
        # group from: :us_core_v610_observation_clinical_result
        # group from: :us_core_v610_observation_pregnancyintent
        # group from: :us_core_v610_observation_pregnancystatus
        # group from: :us_core_v610_observation_sexual_orientation
        # group from: :us_core_v610_observation_screening_assessment
        # group from: :us_core_v610_simple_observation
        # # TODO: add other observation groups
        # group from: :us_core_v610_service_request

        groups.each do |group|
          group.children.select! { |test| test.id.to_s.end_with? 'search_test' }
          group.tests.each { |test| test.include GranularScopeChecker }
        end
      end
    end
  end
end
