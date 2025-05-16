#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'activesupport'
  gem 'fhir_client'
  gem 'byebug'
end

require 'active_support/all'
require 'fhir_client'

BASE_URL = 'http://localhost:4567/custom/us_core_client_v700/fhir'
TOKEN = 'eyJjbGllbnRfaWQiOiJkZW1vIn0' # client_id = demo

client = FHIR::Client.new(BASE_URL)
client.additional_headers = { Authorization: "Bearer #{TOKEN}" }
client.use_r4

FHIR::Model.client = client

def results?(bundle)
  raise "result bundle is unexpectedly empty" unless bundle.total.nonzero?
end

FHIR::Patient.read('us-core-client-tests-patient')
results? FHIR::Patient.search(_id: 'us-core-client-tests-patient')
results? FHIR::Patient.search(name: 'ClientTests')
results? FHIR::Patient.search(identifier: 'us-core-client-tests-patient')
results? FHIR::Patient.search(birthdate: '1940-03-29', name: 'ClientTests')
results? FHIR::Patient.search(gender: 'male', name: 'ClientTests')


FHIR::AllergyIntolerance.read('us-core-client-tests-allergy-intolerance')
results? FHIR::AllergyIntolerance.search(_id: 'us-core-client-tests-allergy-intolerance')
results? FHIR::AllergyIntolerance.search(patient: 'us-core-client-tests-patient')


FHIR::CarePlan.read('us-core-client-tests-care-plan')
results? FHIR::CarePlan.search(_id: 'us-core-client-tests-care-plan')
results? FHIR::CarePlan.search(patient: 'us-core-client-tests-patient', category: 'assess-plan')


FHIR::CareTeam.read('us-core-client-tests-care-team')
results? FHIR::CareTeam.search(_id: 'us-core-client-tests-care-team')
results? FHIR::CareTeam.search(patient: 'us-core-client-tests-patient', status: 'inactive')


FHIR::Condition.read('us-core-client-tests-condition-encounter-diagnosis')
results? FHIR::Condition.search(_id: 'us-core-client-tests-condition-encounter-diagnosis')
results? FHIR::Condition.search(patient: 'us-core-client-tests-patient')
results? FHIR::Condition.search(patient: 'us-core-client-tests-patient', category: 'encounter-diagnosis')


FHIR::Condition.read('us-core-client-tests-condition-problems-health-concerns')
results? FHIR::Condition.search(_id: 'us-core-client-tests-condition-problems-health-concerns')
results? FHIR::Condition.search(patient: 'us-core-client-tests-patient')
results? FHIR::Condition.search(patient: 'us-core-client-tests-patient', category: 'problem-list-item')


FHIR::Coverage.read('us-core-client-tests-coverage')
results? FHIR::Coverage.search(_id: 'us-core-client-tests-coverage')
results? FHIR::Coverage.search(patient: 'us-core-client-tests-patient')


FHIR::Device.read('us-core-client-tests-device')
results? FHIR::Device.search(_id: 'us-core-client-tests-device')
results? FHIR::Device.search(patient: 'us-core-client-tests-patient')


FHIR::DiagnosticReport.read('us-core-client-tests-diagnostic-report-note')
results? FHIR::DiagnosticReport.search(_id: 'us-core-client-tests-diagnostic-report-note')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', category: 'LP29684-5')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', category: 'LP29684-5', date: '2000-03-23T18:33:18-05:00')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', code: '28570-0')


FHIR::DiagnosticReport.read('us-core-client-tests-diagnostic-report-lab')
results? FHIR::DiagnosticReport.search(_id: 'us-core-client-tests-diagnostic-report-lab')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', category: 'LAB')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', category: 'LAB', date: '2017-09-28T19:33:18-04:00')
results? FHIR::DiagnosticReport.search(patient: 'us-core-client-tests-patient', code: '51990-0')


FHIR::DocumentReference.read('us-core-client-tests-document-reference')
results? FHIR::DocumentReference.search(_id: 'us-core-client-tests-document-reference')
results? FHIR::DocumentReference.search(patient: 'us-core-client-tests-patient')
results? FHIR::DocumentReference.search(patient: 'us-core-client-tests-patient', type: '34117-2')
results? FHIR::DocumentReference.search(patient: 'us-core-client-tests-patient', category: 'clinical-note')
results? FHIR::DocumentReference.search(patient: 'us-core-client-tests-patient', category: 'clinical-note', date: '2018-02-28T19:55:18.715-05:00')


FHIR::Encounter.read('us-core-client-tests-encounter')
results? FHIR::Encounter.search(_id: 'us-core-client-tests-encounter')
results? FHIR::Encounter.search(patient: 'us-core-client-tests-patient')
results? FHIR::Encounter.search(patient: 'us-core-client-tests-patient', date: '2018-10-04')


FHIR::Goal.read('us-core-client-tests-goal')
results? FHIR::Goal.search(_id: 'us-core-client-tests-goal')
results? FHIR::Goal.search(patient: 'us-core-client-tests-patient')


FHIR::Immunization.read('us-core-client-tests-immunization')
results? FHIR::Immunization.search(_id: 'us-core-client-tests-immunization')
results? FHIR::Immunization.search(patient: 'us-core-client-tests-patient')


FHIR::MedicationDispense.read('us-core-client-tests-medication-dispense')
results? FHIR::MedicationDispense.search(_id: 'us-core-client-tests-medication-dispense')
results? FHIR::MedicationDispense.search(patient: 'us-core-client-tests-patient')


FHIR::MedicationRequest.read('us-core-client-tests-medication-request')
results? FHIR::MedicationRequest.search(_id: 'us-core-client-tests-medication-request')
results? FHIR::MedicationRequest.search(patient: 'us-core-client-tests-patient', intent: 'order')
results? FHIR::MedicationRequest.search(patient: 'us-core-client-tests-patient', intent: 'order', status: 'stopped')


FHIR::Observation.read('us-core-client-tests-observation-lab')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-lab')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '785-6')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'laboratory')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'laboratory', date: '1972-01-13')


FHIR::Observation.read('us-core-client-tests-observation-pregnancystatus')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-pregnancystatus')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '82810-3')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history', date: '2022-08-24')


FHIR::Observation.read('us-core-client-tests-observation-pregnancyintent')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-pregnancyintent')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '86645-9')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history', date: '2022-09-23')


FHIR::Observation.read('us-core-client-tests-observation-occupation')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-occupation')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '11341-5')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history')


FHIR::Observation.read('us-core-client-tests-respiratory-rate')
results? FHIR::Observation.search(_id: 'us-core-client-tests-respiratory-rate')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '9279-1')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'vital-signs', date: '1999-07-02')


FHIR::Observation.read('us-core-client-tests-simple-observation')
results? FHIR::Observation.search(_id: 'us-core-client-tests-simple-observation')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '11332-4')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'cognitive-status')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'cognitive-status', date: '2022-11-27')


FHIR::Observation.read('us-core-client-tests-treatment-intervention-preference')
results? FHIR::Observation.search(_id: 'us-core-client-tests-treatment-intervention-preference')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '75773-2')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'treatment-intervention-preference')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'treatment-intervention-preference', date: '2023-08-30')


FHIR::Observation.read('us-core-client-tests-care-experience-preference')
results? FHIR::Observation.search(_id: 'us-core-client-tests-care-experience-preference')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '95541-9')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'care-experience-preference')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'care-experience-preference', date: '2023-08-30')


FHIR::Observation.read('us-core-client-tests-heart-rate')
results? FHIR::Observation.search(_id: 'us-core-client-tests-heart-rate')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '8867-4')


FHIR::Observation.read('us-core-client-tests-pediatric-weight-for-height')
results? FHIR::Observation.search(_id: 'us-core-client-tests-pediatric-weight-for-height')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '77606-2')


FHIR::Observation.read('us-core-client-tests-smokingstatus')
results? FHIR::Observation.search(_id: 'us-core-client-tests-smokingstatus')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '72166-2')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history')


FHIR::Observation.read('us-core-client-tests-observation-sexual-orientation')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-sexual-orientation')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '76690-7')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', category: 'social-history', date: '2021-11-11')


FHIR::Observation.read('us-core-client-tests-head-circumference')
results? FHIR::Observation.search(_id: 'us-core-client-tests-head-circumference')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '9843-4')


FHIR::Observation.read('us-core-client-tests-body-height')
results? FHIR::Observation.search(_id: 'us-core-client-tests-body-height')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '8302-2')


FHIR::Observation.read('us-core-client-tests-bmi')
results? FHIR::Observation.search(_id: 'us-core-client-tests-bmi')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '39156-5')


FHIR::Observation.read('us-core-client-tests-average-blood-pressure')
results? FHIR::Observation.search(_id: 'us-core-client-tests-average-blood-pressure')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '96607-7')


FHIR::Observation.read('us-core-client-tests-blood-pressure')
results? FHIR::Observation.search(_id: 'us-core-client-tests-blood-pressure')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '85354-9')


FHIR::Observation.read('us-core-client-tests-pediatric-bmi-for-age')
results? FHIR::Observation.search(_id: 'us-core-client-tests-pediatric-bmi-for-age')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '59576-9')


FHIR::Observation.read('us-core-client-tests-head-circumference-percentile')
results? FHIR::Observation.search(_id: 'us-core-client-tests-head-circumference-percentile')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '8289-1')


FHIR::Observation.read('us-core-client-tests-body-weight')
results? FHIR::Observation.search(_id: 'us-core-client-tests-body-weight')
results? FHIR::Observation.search(patient: 'us-core-client-tests-patient', code: '29463-7')


FHIR::Procedure.read('us-core-client-tests-procedure')
results? FHIR::Procedure.search(_id: 'us-core-client-tests-procedure')
results? FHIR::Procedure.search(patient: 'us-core-client-tests-patient')
results? FHIR::Procedure.search(patient: 'us-core-client-tests-patient', date: '1941-02-13T18:33:18-05:00')


FHIR::QuestionnaireResponse.read('us-core-client-tests-questionnaire-response')
results? FHIR::QuestionnaireResponse.search(_id: 'us-core-client-tests-questionnaire-response')
results? FHIR::QuestionnaireResponse.search(patient: 'us-core-client-tests-patient')


FHIR::ServiceRequest.read('us-core-client-tests-service-request')
results? FHIR::ServiceRequest.search(_id: 'us-core-client-tests-service-request')
results? FHIR::ServiceRequest.search(patient: 'us-core-client-tests-patient')
results? FHIR::ServiceRequest.search(patient: 'us-core-client-tests-patient', code: '467771000124109')
results? FHIR::ServiceRequest.search(patient: 'us-core-client-tests-patient', category: 'sdoh')
results? FHIR::ServiceRequest.search(patient: 'us-core-client-tests-patient', category: 'sdoh', authored: '2021-11-12T10:59:38-08:00')


FHIR::Location.read('us-core-client-tests-location')
results? FHIR::Location.search(_id: 'us-core-client-tests-location')
results? FHIR::Location.search(address: '444 MONTGOMERY STREET')
results? FHIR::Location.search(name: 'RIVER BEND MEDICAL GROUP - CHICOPEE OFFICE - URGENT CARE')


FHIR::Organization.read('us-core-client-tests-organization')
results? FHIR::Organization.search(_id: 'us-core-client-tests-organization')
results? FHIR::Organization.search(address: '444 MONTGOMERY STREET')
results? FHIR::Organization.search(name: 'RIVER BEND MEDICAL GROUP - CHICOPEE OFFICE - URGENT CARE')


FHIR::Practitioner.read('us-core-client-tests-practitioner')
results? FHIR::Practitioner.search(_id: 'us-core-client-tests-practitioner')
results? FHIR::Practitioner.search(identifier: 'us-core-client-tests-practitioner')
results? FHIR::Practitioner.search(name: 'Sammie902')


FHIR::PractitionerRole.read('us-core-client-tests-practitioner-role')
results? FHIR::PractitionerRole.search(_id: 'us-core-client-tests-practitioner-role')
results? FHIR::PractitionerRole.search(practitioner: 'us-core-client-tests-practitioner')
results? FHIR::PractitionerRole.search(specialty: '208D00000X')


FHIR::Provenance.read('us-core-client-tests-provenance')
results? FHIR::Provenance.search(_id: 'us-core-client-tests-provenance')


FHIR::RelatedPerson.read('us-core-client-tests-related-person')
results? FHIR::RelatedPerson.search(_id: 'us-core-client-tests-related-person')


FHIR::Specimen.read('us-core-client-tests-specimen')
results? FHIR::Specimen.search(_id: 'us-core-client-tests-specimen')


FHIR::Observation.read('us-core-client-tests-body-temperature')
results? FHIR::Observation.search(_id: 'us-core-client-tests-body-temperature')


FHIR::Observation.read('us-core-client-tests-pulse-oximetry')
results? FHIR::Observation.search(_id: 'us-core-client-tests-pulse-oximetry')


FHIR::Observation.read('us-core-client-tests-observation-screening-assessment')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-screening-assessment')


FHIR::Observation.read('us-core-client-tests-observation-clinical-result')
results? FHIR::Observation.search(_id: 'us-core-client-tests-observation-clinical-result')

