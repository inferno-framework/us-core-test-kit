# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_wait_group_v311

        title 'Wait for Requests'

        description %(
          
This test will wait for the client under test to submit requests for resources for
each of the US Core profiles, and for requests including all of the required search
parameters for each resource type.

        )

        test do
          id :us_core_client_wait_test_v311

          title 'Wait for Requests'

          description %(
            
This test will wait for the client under test to submit requests for resources for
each of the US Core profiles, and for requests including all of the required search
parameters for each resource type.

          )

          input :access_token

          run do
            wait(
              identifier: access_token,
              message: %(
Inferno will now wait for the client under test to make the required requests against the following base URL:

#{fhir_url}

All requests will be recorded. When finished, the requests will be inspected to ensure that the client under test is making the required requests.

The following requirements will be checked:

* **Patient**
  * read id:
    * us-core-client-tests-patient
  * searches:
    * _id
    * identifier
    * name
    * birthdate + family
    * family + gender
    * birthdate + name
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
    * patient + category + status
    * patient + category + date
* **CareTeam**
  * read id:
    * us-core-client-tests-care-team
  * searches:
    * patient + status
* **Condition**
  * read id:
    * us-core-client-tests-condition
  * searches:
    * patient
    * patient + onset-date
    * patient + category
    * patient + clinical-status
    * patient + code
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
    * patient + code + date
    * patient + code
* **DiagnosticReportLab**
  * read id:
    * us-core-client-tests-diagnostic-report-lab
  * searches:
    * patient + category
    * patient
    * patient + category + date
    * patient + status
    * patient + code + date
    * patient + code
* **DocumentReference**
  * read id:
    * us-core-client-tests-document-reference
  * searches:
    * patient
    * _id
    * patient + type + period
    * patient + type
    * patient + category + date
    * patient + status
    * patient + category
* **Goal**
  * read id:
    * us-core-client-tests-goal
  * searches:
    * patient
    * patient + lifecycle-status
    * patient + target-date
* **Immunization**
  * read id:
    * us-core-client-tests-immunization
  * searches:
    * patient
    * patient + date
    * patient + status
* **MedicationRequest**
  * read id:
    * us-core-client-tests-medication-request
  * searches:
    * patient + intent
    * patient + intent + encounter
    * patient + intent + authoredon
    * patient + intent + status
* **Smokingstatus**
  * read id:
    * us-core-client-tests-smokingstatus
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **PediatricWeightForHeight**
  * read id:
    * us-core-client-tests-pediatric-weight-for-height
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **ObservationLab**
  * read id:
    * us-core-client-tests-observation-lab
  * searches:
    * patient + category
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + code
* **PediatricBmiForAge**
  * read id:
    * us-core-client-tests-pediatric-bmi-for-age
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **PulseOximetry**
  * read id:
    * us-core-client-tests-pulse-oximetry
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **HeadCircumference**
  * read id:
    * us-core-client-tests-head-circumference
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodyheight**
  * read id:
    * us-core-client-tests-bodyheight
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodytemp**
  * read id:
    * us-core-client-tests-bodytemp
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bp**
  * read id:
    * us-core-client-tests-bp
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodyweight**
  * read id:
    * us-core-client-tests-bodyweight
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Heartrate**
  * read id:
    * us-core-client-tests-heartrate
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Resprate**
  * read id:
    * us-core-client-tests-resprate
  * searches:
    * patient + code
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Procedure**
  * read id:
    * us-core-client-tests-procedure
  * searches:
    * patient
    * patient + date
    * patient + status
    * patient + code + date
* **Encounter**
  * read id:
    * us-core-client-tests-encounter
  * searches:
    * patient
    * _id
    * identifier
    * class + patient
    * patient + status
    * patient + type
    * date + patient
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
* **Provenance**
  * read id:
    * us-core-client-tests-provenance
  * searches:


[Click here](#{resume_pass_url}?id=#{access_token}) when finished.
              ),
              timeout: 900
            )
          end
        end
      end
    end
  end
end
