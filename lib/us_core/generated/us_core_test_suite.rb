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
require_relative 'location_group'
require_relative 'medication_group'
require_relative 'organization_group'
require_relative 'practitioner_group'
require_relative 'practitioner_role_group'
require_relative 'provenance_group'

module USCore
  class USCoreTestSuite < Inferno::TestSuite
    title 'US Core 3.1.1'
    # description ''

    id :us_core

    input :url, default: 'https://inferno.healthit.gov/reference-server/r4'
    input :bearer_token, default: 'SAMPLE_TOKEN'

    fhir_client do
      url :url
      bearer_token :bearer_token
    end

    group from: :patient
    group from: :allergy_intolerance
    group from: :care_plan
    group from: :care_team
    group from: :condition
    group from: :device
    group from: :diagnostic_report_note
    group from: :diagnostic_report_lab
    group from: :document_reference
    group from: :goal
    group from: :immunization
    group from: :medication_request
    group from: :smokingstatus
    group from: :pediatric_weight_for_height
    group from: :observation_lab
    group from: :pediatric_bmi_for_age
    group from: :pulse_oximetry
    group from: :head_circumference
    group from: :bodyheight
    group from: :bodytemp
    group from: :bp
    group from: :bodyweight
    group from: :heartrate
    group from: :resprate
    group from: :procedure
    group from: :encounter
    group from: :location
    group from: :medication
    group from: :organization
    group from: :practitioner
    group from: :practitioner_role
    group from: :provenance
  end
end
