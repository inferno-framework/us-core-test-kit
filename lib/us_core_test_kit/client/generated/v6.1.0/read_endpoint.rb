# frozen_string_literal: true

require_relative '../../server_proxy'
require_relative 'tags'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ReadEndpoint < Inferno::DSL::SuiteEndpoint
        include ServerProxy

        def test_run_identifier
          UDAPSecurityTestKit::MockUDAPServer.issued_token_to_client_id(
            request.headers['authorization']&.delete_prefix('Bearer ')
          )
        end

        def make_response
          server_response = proxy_request
          response.status = server_response.status
          response.body = server_response.body
        end

        def proxy_request
          proxy_client.get("#{resource_type}/#{resource_id}", request_params)
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
            when 'Coverage'
              READ_COVERAGE_TAG
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
            when 'MedicationDispense'
              READ_MEDICATION_DISPENSE_TAG
            when 'MedicationRequest'
              READ_MEDICATION_REQUEST_TAG
            when 'Observation'
              READ_OBSERVATION_TAG
            when 'Procedure'
              READ_PROCEDURE_TAG
            when 'QuestionnaireResponse'
              READ_QUESTIONNAIRE_RESPONSE_TAG
            when 'ServiceRequest'
              READ_SERVICE_REQUEST_TAG
            when 'Organization'
              READ_ORGANIZATION_TAG
            when 'Practitioner'
              READ_PRACTITIONER_TAG
            when 'PractitionerRole'
              READ_PRACTITIONER_ROLE_TAG
            when 'Provenance'
              READ_PROVENANCE_TAG
            when 'RelatedPerson'
              READ_RELATED_PERSON_TAG
            when 'Specimen'
              READ_SPECIMEN_TAG
          end
        end

        def resource_id
          request.params[:resource_id]
        end

        def resource_type
          request.params[:resource_type]
        end

        def request_params
          request.params.to_h.except(:resource_id, :resource_type).stringify_keys
        end
      end
    end
  end
end
