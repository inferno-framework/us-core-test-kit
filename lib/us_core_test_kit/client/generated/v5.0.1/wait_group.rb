# frozen_string_literal: true

require 'smart_app_launch_test_kit'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_wait_group_v501
        title 'Wait for Requests'
        description %(
          
This test will wait for the client under test to submit requests for resources for
each of the US Core profiles, and for requests including all of the required search
parameters for each resource type.

        )

        def suite_id
          return config.options[:endpoint_suite_id] if config.options[:endpoint_suite_id].present?
          
          'us_core_client_v501'
        end

        test do
          id :us_core_client_wait_test_v501
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
    * birthdate + family
    * birthdate + name
    * family + gender
    * gender + name
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
    * patient
    * patient + abatement-date
    * patient + asserted-date
    * patient + code
    * patient + category + encounter
    * patient + category
    * patient + recorded-date
    * patient + onset-date
    * patient + clinical-status
* **ConditionProblemsHealthConcerns**
  * read id:
    * us-core-client-tests-condition-problems-health-concerns
  * searches:
    * patient
    * patient + abatement-date
    * patient + asserted-date
    * patient + code
    * patient + category + encounter
    * patient + category
    * patient + recorded-date
    * patient + onset-date
    * patient + clinical-status
* **Device**
  * read id:
    * us-core-client-tests-device
  * searches:
    * patient
    * patient + type
* **DiagnosticReportNote**
  * read id:
    * us-core-client-tests-diagnostic-report-note
  * searches:
    * patient + category
    * patient
    * patient + category + date
    * patient + status
    * patient + code
    * patient + code + date
* **DiagnosticReportLab**
  * read id:
    * us-core-client-tests-diagnostic-report-lab
  * searches:
    * patient + category
    * patient
    * patient + category + date
    * patient + status
    * patient + code
    * patient + code + date
* **DocumentReference**
  * read id:
    * us-core-client-tests-document-reference
  * searches:
    * patient
    * _id
    * patient + category + date
    * patient + status
    * patient + category
    * patient + type + period
    * patient + type
* **Encounter**
  * read id:
    * us-core-client-tests-encounter
  * searches:
    * patient
    * _id
    * identifier
    * patient + discharge-disposition
    * class + patient
    * patient + location
    * date + patient
    * patient + status
    * patient + type
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
    * patient + status
    * patient + date
* **MedicationRequest**
  * read id:
    * us-core-client-tests-medication-request
  * searches:
    * patient + intent
    * patient + intent + status
    * patient + intent + authoredon
    * patient + intent + encounter
* **ObservationLab**
  * read id:
    * us-core-client-tests-observation-lab
  * searches:
    * patient + category
    * patient + category + date
    * patient + code
    * patient + code + date
    * patient + category + status
* **ObservationSdohAssessment**
  * read id:
    * us-core-client-tests-observation-sdoh-assessment
  * searches:
    * patient + category
    * patient + category + date
    * patient + code
    * patient + code + date
    * patient + category + status
* **RespiratoryRate**
  * read id:
    * us-core-client-tests-respiratory-rate
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **ObservationSocialHistory**
  * read id:
    * us-core-client-tests-observation-social-history
  * searches:
    * patient + category
    * patient + category + date
    * patient + code
    * patient + code + date
    * patient + category + status
* **HeartRate**
  * read id:
    * us-core-client-tests-heart-rate
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **BodyTemperature**
  * read id:
    * us-core-client-tests-body-temperature
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **PediatricWeightForHeight**
  * read id:
    * us-core-client-tests-pediatric-weight-for-height
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **PulseOximetry**
  * read id:
    * us-core-client-tests-pulse-oximetry
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **Smokingstatus**
  * read id:
    * us-core-client-tests-smokingstatus
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **ObservationSexualOrientation**
  * read id:
    * us-core-client-tests-observation-sexual-orientation
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **HeadCircumference**
  * read id:
    * us-core-client-tests-head-circumference
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **BodyHeight**
  * read id:
    * us-core-client-tests-body-height
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **Bmi**
  * read id:
    * us-core-client-tests-bmi
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **BloodPressure**
  * read id:
    * us-core-client-tests-blood-pressure
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **ObservationImaging**
  * read id:
    * us-core-client-tests-observation-imaging
  * searches:
    * patient + category
    * patient + category + date
    * patient + code
    * patient + code + date
    * patient + category + status
* **ObservationClinicalTest**
  * read id:
    * us-core-client-tests-observation-clinical-test
  * searches:
    * patient + category
    * patient + category + date
    * patient + code
    * patient + code + date
    * patient + category + status
* **PediatricBmiForAge**
  * read id:
    * us-core-client-tests-pediatric-bmi-for-age
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **HeadCircumferencePercentile**
  * read id:
    * us-core-client-tests-head-circumference-percentile
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **BodyWeight**
  * read id:
    * us-core-client-tests-body-weight
  * searches:
    * patient + code
    * patient + category + date
    * patient + code + date
    * patient + category
    * patient + category + status
* **Procedure**
  * read id:
    * us-core-client-tests-procedure
  * searches:
    * patient
    * patient + code + date
    * patient + status
    * patient + date
* **QuestionnaireResponse**
  * read id:
    * us-core-client-tests-questionnaire-response
  * searches:
    * patient
    * _id
    * patient + authored
    * patient + _tag + authored
    * patient + status
    * patient + _tag
    * patient + questionnaire
* **ServiceRequest**
  * read id:
    * us-core-client-tests-service-request
  * searches:
    * patient
    * _id
    * patient + category + authored
    * patient + status
    * patient + code
    * patient + code + authored
    * patient + category
* **Organization**
  * read id:
    * us-core-client-tests-organization
  * searches:
    * name
    * address
* **Practitioner**
  * read id:
    * us-core-client-tests-practitioner
  * searches:
    * _id
    * name
    * identifier
* **PractitionerRole**
  * read id:
    * us-core-client-tests-practitioner-role
  * searches:
    * specialty
    * practitioner
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

[Click here](#{resume_pass_url}?token=#{client_id}) when finished.
              ),
              timeout: 900
            )
          end
        end
      end
    end
  end
end
