# frozen_string_literal: true

require_relative '../../server_proxy'
require_relative 'tags'
require_relative 'urls'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class SearchEndpoint < Inferno::DSL::SuiteEndpoint
        include ServerProxy
        include URLs

        def test_run_identifier
          UDAPSecurityTestKit::MockUDAPServer.issued_token_to_client_id(
            request.headers['authorization']&.delete_prefix('Bearer ')
          )
        end

        def make_response
          build_proxied_search_response
        end

        def tags
          [SEARCH_REQUEST_TAG, resource_to_tag(resource_type)]
        end

        def resource_to_tag(resource)
          case resource
            when 'Patient'
              SEARCH_PATIENT_TAG
            when 'AllergyIntolerance'
              SEARCH_ALLERGY_INTOLERANCE_TAG
            when 'CarePlan'
              SEARCH_CARE_PLAN_TAG
            when 'CareTeam'
              SEARCH_CARE_TEAM_TAG
            when 'Condition'
              SEARCH_CONDITION_TAG
            when 'Device'
              SEARCH_DEVICE_TAG
            when 'DiagnosticReport'
              SEARCH_DIAGNOSTIC_REPORT_TAG
            when 'DocumentReference'
              SEARCH_DOCUMENT_REFERENCE_TAG
            when 'Goal'
              SEARCH_GOAL_TAG
            when 'Immunization'
              SEARCH_IMMUNIZATION_TAG
            when 'MedicationRequest'
              SEARCH_MEDICATION_REQUEST_TAG
            when 'Observation'
              SEARCH_OBSERVATION_TAG
            when 'Procedure'
              SEARCH_PROCEDURE_TAG
            when 'Encounter'
              SEARCH_ENCOUNTER_TAG
            when 'Organization'
              SEARCH_ORGANIZATION_TAG
            when 'Practitioner'
              SEARCH_PRACTITIONER_TAG
            when 'Provenance'
              SEARCH_PROVENANCE_TAG
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
