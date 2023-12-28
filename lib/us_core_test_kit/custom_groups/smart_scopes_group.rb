require 'smart_app_launch_test_kit'
require_relative '../us_core_options'

module USCoreTestKit
  class SmartScopesGroup < Inferno::TestGroup
    id :us_core_smart_scopes
    title 'US Core SMART Scopes'

    DEFAULT_SMART_V1_SCOPES = "launch/patient openid fhirUser offline_access patient/Medication.read patient/AllergyIntolerance.read patient/CarePlan.read patient/CareTeam.read patient/Condition.read patient/Device.read patient/DiagnosticReport.read patient/DocumentReference.read patient/Encounter.read patient/Goal.read patient/Immunization.read patient/Location.read patient/MedicationRequest.read patient/Observation.read patient/Organization.read patient/Patient.read patient/Practitioner.read patient/Procedure.read patient/Provenance.read patient/PractitionerRole.read".freeze

    DEFAULT_SMART_V2_SCOPES = "launch/patient openid fhirUser offline_access patient/Medication.rs patient/AllergyIntolerance.rs patient/CarePlan.rs patient/CareTeam.rs patient/Condition.rs patient/Device.rs patient/DiagnosticReport.rs patient/DocumentReference.rs patient/Encounter.rs patient/Goal.rs patient/Immunization.rs patient/Location.rs patient/MedicationRequest.rs patient/Observation.rs patient/Organization.rs patient/Patient.rs patient/Practitioner.rs patient/Procedure.rs patient/Provenance.rs patient/PractitionerRole.rs".freeze

    group do
      title 'Resource-Level Scopes'

      group from: :us_core_smart_app_launch do
        groups[0].config(
          inputs: {
            requested_scopes: { default: USCoreTestKit::SmartScopesGroup::DEFAULT_SMART_V1_SCOPES }
          }
        )

        groups[1].config(
          inputs: {
            requested_scopes: { default: USCoreTestKit::SmartScopesGroup::DEFAULT_SMART_V1_SCOPES }
          }
        )

        groups[2].config(
          inputs: {
            requested_scopes: { default: USCoreTestKit::SmartScopesGroup::DEFAULT_SMART_V2_SCOPES }
          }
        )

        groups[3].config(
          inputs: {
            requested_scopes: { default: USCoreTestKit::SmartScopesGroup::DEFAULT_SMART_V2_SCOPES }
          }
        )

        # TODO: verify that all required scopes were requested and received
      end
    end
  end
end
