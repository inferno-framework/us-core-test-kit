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

module USCore
  class USCoreTestSuite < Inferno::TestSuite
    title 'US Core 3.1.1'
    # description ''

    id :us_core_311

    input :url,
      title: 'FHIR Endpoint',
      description: 'URL of the FHIR endpoint',
      default: 'https://inferno.healthit.gov/reference-server/r4'
    input :bearer_token,
      title: 'Bearer Token',
      default: 'SAMPLE_TOKEN'

    fhir_client do
      url :url
      bearer_token :bearer_token
    end

    group from: :us_core_311_patient
    group from: :us_core_311_allergy_intolerance
    group from: :us_core_311_care_plan
    group from: :us_core_311_care_team
    group from: :us_core_311_condition
    group from: :us_core_311_device
    group from: :us_core_311_diagnostic_report_note
    group from: :us_core_311_diagnostic_report_lab
    group from: :us_core_311_document_reference
    group from: :us_core_311_goal
    group from: :us_core_311_immunization
    group from: :us_core_311_medication_request
    group from: :us_core_311_smokingstatus
    group from: :us_core_311_pediatric_weight_for_height
    group from: :us_core_311_observation_lab
    group from: :us_core_311_pediatric_bmi_for_age
    group from: :us_core_311_pulse_oximetry
    group from: :us_core_311_head_circumference
    group from: :us_core_311_bodyheight
    group from: :us_core_311_bodytemp
    group from: :us_core_311_bp
    group from: :us_core_311_bodyweight
    group from: :us_core_311_heartrate
    group from: :us_core_311_resprate
    group from: :us_core_311_procedure
    group from: :us_core_311_encounter
    group from: :us_core_311_organization
    group from: :us_core_311_practitioner
    group from: :us_core_311_provenance
  end
end
