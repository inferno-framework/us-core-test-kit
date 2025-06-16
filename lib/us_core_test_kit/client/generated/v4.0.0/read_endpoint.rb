# frozen_string_literal: true

require_relative '../../server_proxy'
require_relative 'tags'
require_relative 'urls'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ReadEndpoint < Inferno::DSL::SuiteEndpoint
        include ServerProxy
        include URLs

        def test_run_identifier
          SMARTAppLaunch::MockSMARTServer.issued_token_to_client_id(
            request.headers['authorization']&.delete_prefix('Bearer ')
          )
        end

        def make_response
          build_proxied_read_response
        end

        def tags
          [READ_REQUEST_TAG, resource_to_tag(resource_type)]
        end

        def resource_to_tag(resource)
          case resource
            when 'Patient'
              READ_PATIENT_TAG
            when 'AllergyIntolerance'
              READ_ALLERGY_INTOLERANCE_TAG
            when 'CarePlan'
              READ_CARE_PLAN_TAG
            when 'CareTeam'
              READ_CARE_TEAM_TAG
            when 'Condition'
              READ_CONDITION_TAG
            when 'Device'
              READ_DEVICE_TAG
            when 'DiagnosticReport'
              READ_DIAGNOSTIC_REPORT_TAG
            when 'DocumentReference'
              READ_DOCUMENT_REFERENCE_TAG
            when 'Encounter'
              READ_ENCOUNTER_TAG
            when 'Goal'
              READ_GOAL_TAG
            when 'Immunization'
              READ_IMMUNIZATION_TAG
            when 'MedicationRequest'
              READ_MEDICATION_REQUEST_TAG
            when 'Observation'
              READ_OBSERVATION_TAG
            when 'Organization'
              READ_ORGANIZATION_TAG
            when 'Practitioner'
              READ_PRACTITIONER_TAG
            when 'Procedure'
              READ_PROCEDURE_TAG
            when 'Provenance'
              READ_PROVENANCE_TAG
          end
        end

        def resource_type
          request.params[:resource_type]
        end

        def suite_id
          USCoreClientTestSuite.id
        end
      end
    end
  end
end
