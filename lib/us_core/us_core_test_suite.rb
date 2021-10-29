require_relative 'generated/allergy_intolerance_group'
require_relative 'generated/care_plan_group'
require_relative 'generated/care_team_group'
require_relative 'generated/condition_group'
require_relative 'generated/device_group'
require_relative 'generated/diagnostic_report_note_group'
require_relative 'generated/diagnostic_report_lab_group'
require_relative 'generated/document_reference_group'
require_relative 'generated/encounter_group'
require_relative 'generated/goal_group'
require_relative 'generated/immunization_group'
require_relative 'generated/location_group'
require_relative 'generated/medication_group'
require_relative 'generated/medication_request_group'
require_relative 'generated/smokingstatus_group'
require_relative 'generated/pediatric_weight_for_height_group'
require_relative 'generated/observation_lab_group'
require_relative 'generated/pediatric_bmi_for_age_group'
require_relative 'generated/pulse_oximetry_group'
require_relative 'generated/head_circumference_group'
require_relative 'generated/organization_group'
require_relative 'generated/patient_group'
require_relative 'generated/practitioner_group'
require_relative 'generated/practitioner_role_group'
require_relative 'generated/procedure_group'
require_relative 'generated/provenance_group'

module USCore
  class USCoreTestSuite < Inferno::TestSuite
    title 'US Core 3.1.1'
    # description ''

    input :url, :bearer_token

    fhir_client do
      url :url
      bearer_token :bearer_token
    end


    id :us_core

    group from: :allergy_intolerance
    group from: :care_plan
    group from: :care_team
    group from: :condition
    group from: :device
    group from: :diagnostic_report_note
    group from: :diagnostic_report_lab
    group from: :document_reference
    group from: :encounter
    group from: :goal
    group from: :immunization
    group from: :location
    group from: :medication
    group from: :medication_request
    group from: :smokingstatus
    group from: :pediatric_weight_for_height
    group from: :observation_lab
    group from: :pediatric_bmi_for_age
    group from: :pulse_oximetry
    group from: :head_circumference
    group from: :organization
    group from: :patient
    group from: :practitioner
    group from: :practitioner_role
    group from: :procedure
    group from: :provenance
  end
end
