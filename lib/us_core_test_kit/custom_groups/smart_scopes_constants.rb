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
      ].map(&:freeze).freeze
    }.freeze

    SMART_GRANULAR_SCOPE_RESOURCES = [
      'Condition',
      'DiagnosticReport',
      'DocumentReference',
      'Observation',
      'ServiceRequest'
    ].map(&:freeze).freeze
  end
end
