module USCoreTestKit
  module SmartScopesConstants
    DEFAULT_SCOPES = 'launch/patient openid fhirUser offline_access'.freeze

    SMART_GRANULAR_SCOPES_GROUP1 = {
      'v610' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis',
        'patient/Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history'
      ].map(&:freeze).freeze,
      'v700' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis',
        'patient/Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history'
      ].map(&:freeze).freeze,
      'v800_ballot' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis',
        'patient/Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history'
      ].map(&:freeze).freeze
    }.freeze

    SMART_GRANULAR_SCOPES_GROUP2 = {
      'v610' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|survey',
        'patient/Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh'
      ].map(&:freeze).freeze,
      'v700' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|survey',
        'patient/Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh'
      ].map(&:freeze).freeze,
      'v800_ballot' => [
        'patient/Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs',
        'patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|survey',
        'patient/Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh'
      ].map(&:freeze).freeze
    }.freeze

    SMART_GRANULAR_SCOPE_RESOURCES = [
      'Condition',
      'DiagnosticReport',
      'DocumentReference',
      'Observation',
      'ServiceRequest'
    ].map(&:freeze).freeze

    SMART_V1_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.read patient/AllergyIntolerance.read patient/CarePlan.read patient/CareTeam.read patient/Condition.read patient/Coverage.read patient/Device.read patient/DiagnosticReport.read patient/DocumentReference.read patient/Encounter.read patient/Goal.read patient/Immunization.read patient/Location.read patient/Media.read patient/Medication.read patient/MedicationDispense.read patient/MedicationRequest.read patient/Observation.read patient/Organization.read patient/Practitioner.read patient/PractitionerRole.read patient/Procedure.read patient/Provenance.read patient/QuestionnaireResponse.read patient/RelatedPerson.read patient/ServiceRequest.read patient/Specimen.read'.freeze

    SMART_V2_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.rs patient/AllergyIntolerance.rs patient/CarePlan.rs patient/CareTeam.rs patient/Condition.rs patient/Coverage.rs patient/Device.rs patient/DiagnosticReport.rs patient/DocumentReference.rs patient/Encounter.rs patient/Endpoint.rs patient/Goal.rs patient/Immunization.rs patient/Location.rs patient/Media.rs patient/Medication.rs patient/MedicationDispense.rs patient/MedicationRequest.rs patient/Observation.rs patient/Organization.rs patient/Practitioner.rs patient/PractitionerRole.rs patient/Procedure.rs patient/Provenance.rs patient/QuestionnaireResponse.rs patient/RelatedPerson.rs patient/ServiceRequest.rs patient/Specimen.rs'.freeze

    SMART_V2_2_RESOURCE_LEVEL_SCOPES = 'launch/patient openid fhirUser offline_access patient/Patient.rs patient/AllergyIntolerance.rs patient/CarePlan.rs patient/CareTeam.rs patient/Condition.rs patient/Coverage.rs patient/Device.rs patient/DiagnosticReport.rs patient/DocumentReference.rs patient/Encounter.rs patient/Endpoint.rs patient/Goal.rs patient/Immunization.rs patient/Location.rs patient/Media.rs patient/Medication.rs patient/MedicationDispense.rs patient/MedicationRequest.rs patient/Observation.rs patient/Organization.rs patient/Practitioner.rs patient/PractitionerRole.rs patient/Procedure.rs patient/Provenance.rs patient/QuestionnaireResponse.rs patient/RelatedPerson.rs patient/ServiceRequest.rs patient/Specimen.rs'.freeze
  end
end
