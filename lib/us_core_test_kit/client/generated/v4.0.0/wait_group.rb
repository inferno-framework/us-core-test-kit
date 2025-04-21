# frozen_string_literal: true

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

        test do
          id :us_core_client_wait_test_v400

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
    * family + gender
    * birthdate + family
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
    * patient + code
    * patient + onset-date
    * patient + clinical-status
    * patient + category
* **Device**
  * read id:
    * us-core-client-tests-device
  * searches:
    * patient
    * patient + type
* **DiagnosticReportLab**
  * read id:
    * us-core-client-tests-diagnostic-report-lab
  * searches:
    * patient + category
    * patient
    * patient + code + date
    * patient + status
    * patient + category + date
    * patient + code
* **DiagnosticReportNote**
  * read id:
    * us-core-client-tests-diagnostic-report-note
  * searches:
    * patient + category
    * patient
    * patient + code + date
    * patient + status
    * patient + category + date
    * patient + code
* **DocumentReference**
  * read id:
    * us-core-client-tests-document-reference
  * searches:
    * patient
    * _id
    * patient + category
    * patient + status
    * patient + type + period
    * patient + type
    * patient + category + date
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
    * patient + status
    * patient + date
* **MedicationRequest**
  * read id:
    * us-core-client-tests-medication-request
  * searches:
    * patient + intent
    * patient + intent + authoredon
    * patient + intent + encounter
    * patient + intent + status
* **ObservationLab**
  * read id:
    * us-core-client-tests-observation-lab
  * searches:
    * patient + category
    * patient + category + status
    * patient + code + date
    * patient + category + date
    * patient + code
* **BloodPressure**
  * read id:
    * us-core-client-tests-blood-pressure
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **Bmi**
  * read id:
    * us-core-client-tests-bmi
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **HeadCircumference**
  * read id:
    * us-core-client-tests-head-circumference
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **BodyHeight**
  * read id:
    * us-core-client-tests-body-height
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **BodyWeight**
  * read id:
    * us-core-client-tests-body-weight
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **BodyTemperature**
  * read id:
    * us-core-client-tests-body-temperature
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **HeartRate**
  * read id:
    * us-core-client-tests-heart-rate
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **PediatricBmiForAge**
  * read id:
    * us-core-client-tests-pediatric-bmi-for-age
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **HeadCircumferencePercentile**
  * read id:
    * us-core-client-tests-head-circumference-percentile
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **PediatricWeightForHeight**
  * read id:
    * us-core-client-tests-pediatric-weight-for-height
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **PulseOximetry**
  * read id:
    * us-core-client-tests-pulse-oximetry
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **RespiratoryRate**
  * read id:
    * us-core-client-tests-respiratory-rate
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **Smokingstatus**
  * read id:
    * us-core-client-tests-smokingstatus
  * searches:
    * patient + code
    * patient + category + status
    * patient + code + date
    * patient + category
    * patient + category + date
* **Procedure**
  * read id:
    * us-core-client-tests-procedure
  * searches:
    * patient
    * patient + code + date
    * patient + date
    * patient + status
* **Encounter**
  * read id:
    * us-core-client-tests-encounter
  * searches:
    * patient
    * _id
    * identifier
    * date + patient
    * patient + status
    * class + patient
    * patient + type
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
