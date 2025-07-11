# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_access_group_v700
        title 'Client Access'
        description %(
          During these tests, Inferno will simulate a US Core FHIR Server for the client to
          use to access data. Inferno will wait while the client submits requests and will
          both respond with data and collect the requests for later analysis.
        )

        run_as_group

        def suite_id
          return config.options[:endpoint_suite_id] if config.options[:endpoint_suite_id].present?
          
          'us_core_client_v700'
        end

        group do
          id :us_core_client_wait_group_v700
          title 'Perform Data Access'

          test do
            id :us_core_client_wait_test_v700
            title 'Wait for Requests'
            description %(
              This test will wait for the client under test to submit requests for resources for
              each of the US Core profiles, and for requests including all of the required search
              parameters for each resource type.
            )

            input :client_id,
                  title: 'Client Id',
                  type: 'text',
                  optional: true,
                  locked: true,
                  description: SMARTAppLaunch::INPUT_CLIENT_ID_DESCRIPTION_LOCKED
            input :smart_launch_urls,
                  title: 'SMART App Launch URL(s)',
                  type: 'textarea',
                  locked: true,
                  optional: true,
                  description: SMARTAppLaunch::INPUT_SMART_LAUNCH_URLS_DESCRIPTION_LOCKED
            input :launch_context,
                  title: 'Launch Context',
                  type: 'textarea',
                  optional: true,
                  description: SMARTAppLaunch::INPUT_LAUNCH_CONTEXT_DESCRIPTION       
            input :fhir_user_relative_reference,
                  title: 'FHIR User Relative Reference',
                  type: 'text',
                  optional: true,
                  description: %(
                    A FHIR relative reference (<resource type>/<id>) for the FHIR user record to return
                    when the openid and fhirUser scopes are requested. If populated, ensure that the
                    referenced resource is available in Inferno's simulated FHIR server so that it can
                    be accessed.
                  )
            
            input_order :launch_context, :fhir_user_relative_reference, :smart_launch_urls, :client_id
            output :launch_key
            config options: { accepts_multiple_requests: true }

            run do
              if smart_launch_urls.present?
                launch_key = SecureRandom.hex(32)
                output(launch_key:)
              end
              
              wait(
                identifier: client_id,
                message: %(
  Inferno will now wait for the client under test to make the required requests against the following base URL:

  #{fhir_url}

  All requests will be recorded. When finished, the requests will be inspected to ensure that the client under test is making the required requests.
  Requests should target the following patient record:
  - **Resource ID**: `us-core-client-tests-patient`
  - **Name**: ClientTests USCore
  - **Member Identifier**: `us-core-client-tests-patient` (system: `urn:inferno:mrn`)
  - **Date of Birth**: 1940-03-29
  - **Gender**: male

  [Click here](#{resume_pass_url}?token=#{client_id}) when finished.

  The following requirements will be checked:

  * **Patient**
  * read id:
    * us-core-client-tests-patient
  * searches:
    * _id
    * identifier
    * name
    * birthdate + name
    * family + gender
    * birthdate + family
    * gender + name
    * death-date + family
* **AllergyIntolerance**
  * read id:
    * us-core-client-tests-allergy-intolerance
  * searches:
    * patient
    * patient + clinical-status
* **CarePlan**
  * read id:
    * us-core-client-tests-care-plan
  * searches:
    * patient + category
    * patient + category + status + date
    * patient + category + date
    * patient + category + status
* **CareTeam**
  * read id:
    * us-core-client-tests-care-team
  * searches:
    * patient + status
    * role
    * patient + role
* **ConditionEncounterDiagnosis**
  * read id:
    * us-core-client-tests-condition-encounter-diagnosis
  * searches:
    * patient + category
    * patient
    * patient + category + clinical-status
    * patient + onset-date
    * patient + abatement-date
    * patient + clinical-status
    * patient + asserted-date
    * patient + code
    * patient + category + encounter
    * patient + _lastUpdated
    * patient + recorded-date
* **ConditionProblemsHealthConcerns**
  * read id:
    * us-core-client-tests-condition-problems-health-concerns
  * searches:
    * patient + category
    * patient
    * patient + category + clinical-status
    * patient + onset-date
    * patient + abatement-date
    * patient + clinical-status
    * patient + asserted-date
    * patient + code
    * patient + category + encounter
    * patient + _lastUpdated
    * patient + recorded-date
* **Coverage**
  * read id:
    * us-core-client-tests-coverage
  * searches:
    * patient
* **Device**
  * read id:
    * us-core-client-tests-device
  * searches:
    * patient
    * patient + status
    * patient + type
* **DiagnosticReportNote**
  * read id:
    * us-core-client-tests-diagnostic-report-note
  * searches:
    * patient + category
    * patient
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + status
    * patient + category + _lastUpdated
* **DiagnosticReportLab**
  * read id:
    * us-core-client-tests-diagnostic-report-lab
  * searches:
    * patient + category
    * patient
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + status
    * patient + category + _lastUpdated
* **DocumentReference**
  * read id:
    * us-core-client-tests-document-reference
  * searches:
    * patient
    * _id
    * patient + type
    * patient + category + date
    * patient + type + period
    * patient + status
    * patient + category
* **Encounter**
  * read id:
    * us-core-client-tests-encounter
  * searches:
    * patient
    * _id
    * identifier
    * date + patient
    * class + patient
    * patient + type
    * patient + _lastUpdated
    * patient + status
    * patient + location
    * patient + discharge-disposition
* **Goal**
  * read id:
    * us-core-client-tests-goal
  * searches:
    * patient
    * patient + target-date
    * patient + lifecycle-status
    * patient + description
* **Immunization**
  * read id:
    * us-core-client-tests-immunization
  * searches:
    * patient
    * patient + date
    * patient + status
* **MedicationDispense**
  * read id:
    * us-core-client-tests-medication-dispense
  * searches:
    * patient
    * patient + status + type
    * patient + status
* **MedicationRequest**
  * read id:
    * us-core-client-tests-medication-request
  * searches:
    * patient + intent
    * patient + intent + encounter
    * patient + intent + authoredon
    * patient + intent + status
* **ObservationLab**
  * read id:
    * us-core-client-tests-observation-lab
  * searches:
    * patient + category
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
* **ObservationPregnancystatus**
  * read id:
    * us-core-client-tests-observation-pregnancystatus
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **ObservationPregnancyintent**
  * read id:
    * us-core-client-tests-observation-pregnancyintent
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **ObservationOccupation**
  * read id:
    * us-core-client-tests-observation-occupation
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **RespiratoryRate**
  * read id:
    * us-core-client-tests-respiratory-rate
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **SimpleObservation**
  * read id:
    * us-core-client-tests-simple-observation
  * searches:
    * patient + category
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
* **TreatmentInterventionPreference**
  * read id:
    * us-core-client-tests-treatment-intervention-preference
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **CareExperiencePreference**
  * read id:
    * us-core-client-tests-care-experience-preference
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **HeartRate**
  * read id:
    * us-core-client-tests-heart-rate
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **BodyTemperature**
  * read id:
    * us-core-client-tests-body-temperature
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **PediatricWeightForHeight**
  * read id:
    * us-core-client-tests-pediatric-weight-for-height
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **PulseOximetry**
  * read id:
    * us-core-client-tests-pulse-oximetry
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **Smokingstatus**
  * read id:
    * us-core-client-tests-smokingstatus
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **ObservationSexualOrientation**
  * read id:
    * us-core-client-tests-observation-sexual-orientation
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **HeadCircumference**
  * read id:
    * us-core-client-tests-head-circumference
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **BodyHeight**
  * read id:
    * us-core-client-tests-body-height
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **Bmi**
  * read id:
    * us-core-client-tests-bmi
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **ObservationScreeningAssessment**
  * read id:
    * us-core-client-tests-observation-screening-assessment
  * searches:
    * patient + category
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
* **AverageBloodPressure**
  * read id:
    * us-core-client-tests-average-blood-pressure
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **BloodPressure**
  * read id:
    * us-core-client-tests-blood-pressure
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **ObservationClinicalResult**
  * read id:
    * us-core-client-tests-observation-clinical-result
  * searches:
    * patient + category
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
* **PediatricBmiForAge**
  * read id:
    * us-core-client-tests-pediatric-bmi-for-age
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **HeadCircumferencePercentile**
  * read id:
    * us-core-client-tests-head-circumference-percentile
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **BodyWeight**
  * read id:
    * us-core-client-tests-body-weight
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category + status
    * patient + category + _lastUpdated
    * patient + category
* **Procedure**
  * read id:
    * us-core-client-tests-procedure
  * searches:
    * patient
    * patient + code + date
    * patient + date
    * patient + status
* **QuestionnaireResponse**
  * read id:
    * us-core-client-tests-questionnaire-response
  * searches:
    * patient
    * _id
    * patient + questionnaire
    * patient + authored
    * patient + status
* **ServiceRequest**
  * read id:
    * us-core-client-tests-service-request
  * searches:
    * patient
    * _id
    * patient + code
    * patient + category + authored
    * patient + code + authored
    * patient + status
    * patient + category
* **Location**
  * read id:
    * us-core-client-tests-location
  * searches:
    * address
    * address-city
    * address-postalcode
    * address-state
    * name
* **Organization**
  * read id:
    * us-core-client-tests-organization
  * searches:
    * address
    * name
* **Practitioner**
  * read id:
    * us-core-client-tests-practitioner
  * searches:
    * _id
    * identifier
    * name
* **PractitionerRole**
  * read id:
    * us-core-client-tests-practitioner-role
  * searches:
    * practitioner
    * specialty
* **Provenance**
  * read id:
    * us-core-client-tests-provenance
  * searches:

* **RelatedPerson**
  * read id:
    * us-core-client-tests-related-person
  * searches:
    * patient
    * _id
    * name
    * patient + name
* **Specimen**
  * read id:
    * us-core-client-tests-specimen
  * searches:
    * patient
    * _id

  [Click here](#{resume_pass_url}?token=#{client_id}) when finished.
                ),
                timeout: 900
              )
            end
          end
        end

        group from: :us_core_client_v700_auth_smart_alca,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        group from: :us_core_client_v700_auth_smart_alcs,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        group from: :us_core_client_v700_auth_smart_alp,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }
      end
    end
  end
end
