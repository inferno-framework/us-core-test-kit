# frozen_string_literal: true

require 'smart_app_launch_test_kit'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_wait_group_v400
        title 'Wait for Requests'
        description %(
          
This test will wait for the client under test to submit requests for resources for
each of the US Core profiles, and for requests including all of the required search
parameters for each resource type.

        )

        def suite_id
          return config.options[:endpoint_suite_id] if config.options[:endpoint_suite_id].present?
          
          'us_core_client_v400'
        end

        test do
          id :us_core_client_wait_test_v400
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
    * birthdate
    * family
    * gender
    * given
    * identifier
    * name
    * gender + name
    * family + gender
    * birthdate + family
    * birthdate + name
* **AllergyIntolerance**
  * read id:
    * us-core-client-tests-allergy-intolerance
  * searches:
    * patient
    * clinical-status
    * patient + clinical-status
* **CarePlan**
  * read id:
    * us-core-client-tests-care-plan
  * searches:
    * patient + category
    * category
    * date
    * patient
    * status
    * patient + category + date
    * patient + category + status + date
    * patient + category + status
* **CareTeam**
  * read id:
    * us-core-client-tests-care-team
  * searches:
    * patient + status
    * patient
    * status
* **Condition**
  * read id:
    * us-core-client-tests-condition
  * searches:
    * patient
    * category
    * clinical-status
    * onset-date
    * code
    * patient + code
    * patient + onset-date
    * patient + clinical-status
    * patient + category
* **Device**
  * read id:
    * us-core-client-tests-device
  * searches:
    * patient
    * type
    * patient + type
* **DiagnosticReportLab**
  * read id:
    * us-core-client-tests-diagnostic-report-lab
  * searches:
    * patient + category
    * status
    * patient
    * category
    * code
    * date
    * patient + code
    * patient + code + date
    * patient + category + date
    * patient + status
* **DiagnosticReportNote**
  * read id:
    * us-core-client-tests-diagnostic-report-note
  * searches:
    * patient + category
    * status
    * patient
    * category
    * code
    * date
    * patient + code
    * patient + code + date
    * patient + category + date
    * patient + status
* **DocumentReference**
  * read id:
    * us-core-client-tests-document-reference
  * searches:
    * patient
    * _id
    * status
    * category
    * type
    * date
    * period
    * patient + category + date
    * patient + status
    * patient + type
    * patient + type + period
    * patient + category
* **Encounter**
  * read id:
    * us-core-client-tests-encounter
  * searches:
    * patient
    * _id
    * class
    * date
    * identifier
    * status
    * type
    * patient + type
    * patient + status
    * class + patient
    * date + patient
* **Goal**
  * read id:
    * us-core-client-tests-goal
  * searches:
    * patient
    * lifecycle-status
    * target-date
    * patient + lifecycle-status
    * patient + target-date
* **Immunization**
  * read id:
    * us-core-client-tests-immunization
  * searches:
    * patient
    * status
    * date
    * patient + status
    * patient + date
* **MedicationRequest**
  * read id:
    * us-core-client-tests-medication-request
  * searches:
    * patient + intent
    * status
    * intent
    * patient
    * encounter
    * authoredon
    * patient + intent + status
    * patient + intent + authoredon
    * patient + intent + encounter
* **ObservationLab**
  * read id:
    * us-core-client-tests-observation-lab
  * searches:
    * patient + category
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code
    * patient + code + date
    * patient + category + date
* **BloodPressure**
  * read id:
    * us-core-client-tests-blood-pressure
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **Bmi**
  * read id:
    * us-core-client-tests-bmi
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **HeadCircumference**
  * read id:
    * us-core-client-tests-head-circumference
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **BodyHeight**
  * read id:
    * us-core-client-tests-body-height
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **BodyWeight**
  * read id:
    * us-core-client-tests-body-weight
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **BodyTemperature**
  * read id:
    * us-core-client-tests-body-temperature
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **HeartRate**
  * read id:
    * us-core-client-tests-heart-rate
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **PediatricBmiForAge**
  * read id:
    * us-core-client-tests-pediatric-bmi-for-age
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **HeadCircumferencePercentile**
  * read id:
    * us-core-client-tests-head-circumference-percentile
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **PediatricWeightForHeight**
  * read id:
    * us-core-client-tests-pediatric-weight-for-height
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **PulseOximetry**
  * read id:
    * us-core-client-tests-pulse-oximetry
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **RespiratoryRate**
  * read id:
    * us-core-client-tests-respiratory-rate
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + category
* **Smokingstatus**
  * read id:
    * us-core-client-tests-smokingstatus
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + status
    * patient + code + date
    * patient + category + date
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
    * name
    * identifier
* **Procedure**
  * read id:
    * us-core-client-tests-procedure
  * searches:
    * patient
    * status
    * date
    * code
    * patient + code + date
    * patient + status
    * patient + date
* **Provenance**
  * read id:
    * us-core-client-tests-provenance
  * searches:


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
