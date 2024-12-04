require 'smart_app_launch_test_kit'
require_relative '../us_core_options'
require_relative 'smart_ehr_launch_stu1'
require_relative 'smart_ehr_launch_stu2'
require_relative 'smart_ehr_launch_stu2_2'
require_relative 'smart_standalone_launch_stu1_group'
require_relative 'smart_standalone_launch_stu2_group'
require_relative 'smart_standalone_launch_stu2_2_group'

module USCoreTestKit
  class SmartAppLaunchGroup < Inferno::TestGroup
    id :us_core_smart_app_launch
    title 'SMART App Launch'

    SMART_V1_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.read patient/AllergyIntolerance.read patient/CarePlan.read patient/CareTeam.read patient/Condition.read patient/Coverage.read patient/Device.read patient/DiagnosticReport.read patient/DocumentReference.read patient/Encounter.read patient/Goal.read patient/Immunization.read patient/Location.read patient/Media.read patient/Medication.read patient/MedicationDispense.read patient/MedicationRequest.read patient/Observation.read patient/Organization.read patient/Practitioner.read patient/PractitionerRole.read patient/Procedure.read patient/Provenance.read patient/RelatedPerson.read patient/ServiceRequest.read patient/Specimen.read'.freeze

    SMART_V2_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.rs patient/AllergyIntolerance.rs patient/CarePlan.rs patient/CareTeam.rs patient/Condition.rs patient/Coverage.rs patient/Device.rs patient/DiagnosticReport.rs patient/DocumentReference.rs patient/Encounter.rs patient/Endpoint.rs patient/Goal.rs patient/Immunization.rs patient/Location.rs patient/Media.rs patient/Medication.rs patient/MedicationDispense.rs patient/MedicationRequest.rs patient/Observation.rs patient/Organization.rs patient/Practitioner.rs patient/PractitionerRole.rs patient/Procedure.rs patient/Provenance.rs patient/RelatedPerson.rs patient/ServiceRequest.rs patient/Specimen.rs'.freeze

    SMART_V2_2_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.rs patient/AllergyIntolerance.rs patient/CarePlan.rs patient/CareTeam.rs patient/Condition.rs patient/Coverage.rs patient/Device.rs patient/DiagnosticReport.rs patient/DocumentReference.rs patient/Encounter.rs patient/Endpoint.rs patient/Goal.rs patient/Immunization.rs patient/Location.rs patient/Media.rs patient/Medication.rs patient/MedicationDispense.rs patient/MedicationRequest.rs patient/Observation.rs patient/Organization.rs patient/Practitioner.rs patient/PractitionerRole.rs patient/Procedure.rs patient/Provenance.rs patient/RelatedPerson.rs patient/ServiceRequest.rs patient/Specimen.rs'.freeze

    group from: :us_core_smart_standalone_launch_stu1,
          required_suite_options: USCoreOptions::SMART_1_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V1_RESOURCE_LEVEL_SCOPES }
            }
          }

    group from: :us_core_smart_ehr_launch_stu1,
          required_suite_options: USCoreOptions::SMART_1_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V1_RESOURCE_LEVEL_SCOPES }
            }
          }

    group from: :us_core_smart_standalone_launch_stu2,
          required_suite_options: USCoreOptions::SMART_2_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V2_RESOURCE_LEVEL_SCOPES }
            }
          }

    group from: :us_core_smart_ehr_launch_stu2,
          required_suite_options: USCoreOptions::SMART_2_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V2_RESOURCE_LEVEL_SCOPES }
            }
          }

    group from: :us_core_smart_standalone_launch_stu2_2,
          required_suite_options: USCoreOptions::SMART_2_2_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V2_2_RESOURCE_LEVEL_SCOPES }
            }
          }

    group from: :us_core_smart_ehr_launch_stu2_2,
          required_suite_options: USCoreOptions::SMART_2_2_REQUIREMENT,
          optional: true,
          config: {
            inputs: {
              requested_scopes: { default: SmartAppLaunchGroup::SMART_V2_2_RESOURCE_LEVEL_SCOPES }
            }
          }
  end
end
