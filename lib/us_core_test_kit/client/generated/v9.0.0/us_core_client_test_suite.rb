# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require_relative '../../../version'
require_relative 'tags'
require_relative 'urls'
require_relative 'metadata_helper'
require_relative 'read_endpoint'
require_relative 'search_endpoint'
require_relative 'token_endpoint'
require_relative 'test_helper'
require_relative '../../us_core_client_options'
require_relative 'registration_group'
require_relative 'wait_group'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'
require_relative 'patient_client_group'
require_relative 'allergy_intolerance_client_group'
require_relative 'care_plan_client_group'
require_relative 'care_team_client_group'
require_relative 'condition_encounter_diagnosis_client_group'
require_relative 'condition_problems_health_concerns_client_group'
require_relative 'coverage_client_group'
require_relative 'device_client_group'
require_relative 'diagnostic_report_note_client_group'
require_relative 'diagnostic_report_lab_client_group'
require_relative 'document_reference_client_group'
require_relative 'adi_document_reference_client_group'
require_relative 'encounter_client_group'
require_relative 'family_member_history_client_group'
require_relative 'goal_client_group'
require_relative 'immunization_client_group'
require_relative 'medication_dispense_client_group'
require_relative 'medication_request_client_group'
require_relative 'observation_adi_documentation_client_group'
require_relative 'observation_lab_client_group'
require_relative 'observation_pregnancystatus_client_group'
require_relative 'observation_pregnancyintent_client_group'
require_relative 'observation_occupation_client_group'
require_relative 'respiratory_rate_client_group'
require_relative 'simple_observation_client_group'
require_relative 'treatment_intervention_preference_client_group'
require_relative 'care_experience_preference_client_group'
require_relative 'heart_rate_client_group'
require_relative 'body_temperature_client_group'
require_relative 'pediatric_weight_for_height_client_group'
require_relative 'pulse_oximetry_client_group'
require_relative 'smokingstatus_client_group'
require_relative 'observation_sexual_orientation_client_group'
require_relative 'head_circumference_client_group'
require_relative 'body_height_client_group'
require_relative 'bmi_client_group'
require_relative 'observation_screening_assessment_client_group'
require_relative 'average_blood_pressure_client_group'
require_relative 'blood_pressure_client_group'
require_relative 'observation_clinical_result_client_group'
require_relative 'pediatric_bmi_for_age_client_group'
require_relative 'head_circumference_percentile_client_group'
require_relative 'body_weight_client_group'
require_relative 'procedure_client_group'
require_relative 'questionnaire_response_client_group'
require_relative 'service_request_client_group'
require_relative 'location_client_group'
require_relative 'organization_client_group'
require_relative 'practitioner_client_group'
require_relative 'practitioner_role_client_group'
require_relative 'provenance_client_group'
require_relative 'related_person_client_group'
require_relative 'specimen_client_group'

module USCoreTestKit
  module Client
    module USCoreClientV900
      class USCoreClientTestSuite < Inferno::TestSuite
        include URLs

        id :us_core_client_v900
        title 'US Core Client v9.0.0'
        description %(
          This draft suite evaluates client read and search requests for the
          [US Core v9 profiles](http://hl7.org/fhir/us/core/STU9).

          Run Client Registration first, then Read & Search. Inferno proxies requests
          to the configured reference server and records them for evaluation. Finish
          using the link in the waiting dialog. Profile groups are optional, following
          the existing client suite policy; at least one profile group must pass.

          Requests are evaluated for target resource IDs and required search parameter
          combinations. These tests do not validate response resources or prove that a
          client processes their content. See the Available Instances table in the v9
          client setup documentation for the target IDs and reference-server fixtures.
        )

        links [
          {
            type: 'report_issue',
            label: 'Report Issue',
            url: 'https://github.com/inferno-framework/us-core-test-kit/issues/'
          },
          {
            type: 'source_code',
            label: 'Open Source',
            url: 'https://github.com/inferno-framework/us-core-test-kit/'
          },
          {
            type: 'download',
            label: 'Download',
            url: 'https://github.com/inferno-framework/us-core-test-kit/releases/'
          },
          {
            label: 'Implementation Guide',
            url: 'http://hl7.org/fhir/us/core/STU9'
          }
        ]

        requirement_sets(
          {
            identifier: 'hl7.fhir.us.core_9.0.0',
            title: 'US Core Implementation Guide',
            actor: 'Client'
          }
        )


        suite_option :client_type,
                      title: 'Client Security Type',
                      list_options: [
                        {
                          label: 'SMART App Launch Public Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
                        },
                        {
                          label: 'SMART App Launch Confidential Symmetric Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
                        },
                        {
                          label: 'SMART App Launch Confidential Asymmetric Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
                        }
                      ]

        route(:get, METADATA_PATH, MetadataHelper.get_metadata)
        route(:get, SMARTAppLaunch::SMART_DISCOVERY_PATH, lambda { |_env|
          SMARTAppLaunch::MockSMARTServer.smart_server_metadata(id)
        })
        route(:get, SMARTAppLaunch::OIDC_DISCOVERY_PATH, ->(_env) { SMARTAppLaunch::MockSMARTServer.openid_connect_metadata(id) })
        route(
          :get,
          SMARTAppLaunch::OIDC_JWKS_PATH,
          ->(_env) { [200, { 'Content-Type' => 'application/json' }, [SMARTAppLaunch::OIDCJWKS.jwks_json]] }
        )

        suite_endpoint :post, SMARTAppLaunch::TOKEN_PATH, TokenEndpoint
        suite_endpoint :get,  SMARTAppLaunch::AUTHORIZATION_PATH, SMARTAppLaunch::MockSMARTServer::AuthorizationEndpoint
        suite_endpoint :post, SMARTAppLaunch::AUTHORIZATION_PATH, SMARTAppLaunch::MockSMARTServer::AuthorizationEndpoint

        suite_endpoint :post, SEARCH_POST_ROUTE, SearchEndpoint
        suite_endpoint :get, SEARCH_ROUTE, SearchEndpoint
        suite_endpoint :get, READ_ROUTE, ReadEndpoint

        resume_test_route :get, RESUME_PASS_ROUTE do |request|
          request.query_parameters['token']
        end

        group from: :us_core_client_v900_registration

        group do
          id :us_core_client_read_search_group_v900
          title 'Read & Search'
          description %(
            During these tests, the client will interact with Inferno's simulated
            US Core server and demonstrate its ability to read and search resources
            for the US Core v9 profiles.
          )

          group from: :us_core_client_access_group_v900

          group from: :us_core_client_v900_patient
          group from: :us_core_client_v900_allergy_intolerance
          group from: :us_core_client_v900_care_plan
          group from: :us_core_client_v900_care_team
          group from: :us_core_client_v900_condition_encounter_diagnosis
          group from: :us_core_client_v900_condition_problems_health_concerns
          group from: :us_core_client_v900_coverage
          group from: :us_core_client_v900_device
          group from: :us_core_client_v900_diagnostic_report_note
          group from: :us_core_client_v900_diagnostic_report_lab
          group from: :us_core_client_v900_document_reference
          group from: :us_core_client_v900_adi_document_reference
          group from: :us_core_client_v900_encounter
          group from: :us_core_client_v900_family_member_history
          group from: :us_core_client_v900_goal
          group from: :us_core_client_v900_immunization
          group from: :us_core_client_v900_medication_dispense
          group from: :us_core_client_v900_medication_request
          group from: :us_core_client_v900_observation_adi_documentation
          group from: :us_core_client_v900_observation_lab
          group from: :us_core_client_v900_observation_pregnancystatus
          group from: :us_core_client_v900_observation_pregnancyintent
          group from: :us_core_client_v900_observation_occupation
          group from: :us_core_client_v900_respiratory_rate
          group from: :us_core_client_v900_simple_observation
          group from: :us_core_client_v900_treatment_intervention_preference
          group from: :us_core_client_v900_care_experience_preference
          group from: :us_core_client_v900_heart_rate
          group from: :us_core_client_v900_body_temperature
          group from: :us_core_client_v900_pediatric_weight_for_height
          group from: :us_core_client_v900_pulse_oximetry
          group from: :us_core_client_v900_smokingstatus
          group from: :us_core_client_v900_observation_sexual_orientation
          group from: :us_core_client_v900_head_circumference
          group from: :us_core_client_v900_body_height
          group from: :us_core_client_v900_bmi
          group from: :us_core_client_v900_observation_screening_assessment
          group from: :us_core_client_v900_average_blood_pressure
          group from: :us_core_client_v900_blood_pressure
          group from: :us_core_client_v900_observation_clinical_result
          group from: :us_core_client_v900_pediatric_bmi_for_age
          group from: :us_core_client_v900_head_circumference_percentile
          group from: :us_core_client_v900_body_weight
          group from: :us_core_client_v900_procedure
          group from: :us_core_client_v900_questionnaire_response
          group from: :us_core_client_v900_service_request
          group from: :us_core_client_v900_location
          group from: :us_core_client_v900_organization
          group from: :us_core_client_v900_practitioner
          group from: :us_core_client_v900_practitioner_role
          group from: :us_core_client_v900_provenance
          group from: :us_core_client_v900_related_person
          group from: :us_core_client_v900_specimen

          run do
            passing_profile_group = groups.find do |group|
              next if group.id.end_with?('us_core_client_access_group_v900')

              results[group.id]&.result == 'pass'
            end
            assert passing_profile_group.present?, 'At least one profile group must pass.'
          end
        end
      end
    end
  end
end
