# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_access_group_v311
        title 'Client Access'
        description %(
          During these tests, Inferno will simulate a US Core FHIR Server for the client to
          use to access data. Inferno will wait while the client submits requests and will
          both respond with data and collect the requests for later analysis.
        )

        run_as_group

        def suite_id
          return config.options[:endpoint_suite_id] if config.options[:endpoint_suite_id].present?
          
          'us_core_client_v311'
        end

        group do
          id :us_core_client_wait_group_v311
          title 'Perform Data Access'

          test do
            id :us_core_client_wait_test_v311
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
    * birthdate + family
    * family + gender
    * birthdate + name
    * gender + name
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
    * patient + category + status + date
    * patient + category + status
    * patient + category + date
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
    * patient + onset-date
    * patient + category
    * patient + clinical-status
    * patient + code
* **Device**
  * read id:
    * us-core-client-tests-device
  * searches:
    * patient
    * type
    * patient + type
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
    * patient + category + date
    * patient + status
    * patient + code + date
    * patient + code
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
    * status
    * category
    * type
    * date
    * period
    * patient + type + period
    * patient + type
    * patient + category + date
    * patient + status
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
    * class + patient
    * patient + status
    * patient + type
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
    * patient + date
    * patient + status
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
    * patient + intent + encounter
    * patient + intent + authoredon
    * patient + intent + status
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + code
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
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
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodyheight**
  * read id:
    * us-core-client-tests-bodyheight
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodytemp**
  * read id:
    * us-core-client-tests-bodytemp
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bp**
  * read id:
    * us-core-client-tests-bp
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Bodyweight**
  * read id:
    * us-core-client-tests-bodyweight
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Heartrate**
  * read id:
    * us-core-client-tests-heartrate
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
    * patient + category
* **Resprate**
  * read id:
    * us-core-client-tests-resprate
  * searches:
    * patient + code
    * status
    * category
    * code
    * date
    * patient
    * patient + category + date
    * patient + category + status
    * patient + code + date
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
    * patient + date
    * patient + status
    * patient + code + date
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

        group from: :us_core_client_v311_auth_smart_alca,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        group from: :us_core_client_v311_auth_smart_alcs,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        group from: :us_core_client_v311_auth_smart_alp,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }
      end
    end
  end
end
