module USCoreTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = {
        'Location' => ['v311', 'v400', 'v501', 'v610'],
        'Medication' => ['v311', 'v400', 'v501', 'v610', 'v700'],
        'PractitionerRole' => ['v311', 'v400']
      }.freeze

      PROFILES_TO_EXCLUDE = [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-survey',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs'
      ].freeze

      OPTIONAL_RESOURCES = [
        'PractitionerRole',
        'QuestionnaireResponse'
      ].freeze

      # us-core-observation-sexual-orientation is changed to optional as ASTP/ONC enforcement discretion issued on March 21, 2025:
      # https://www.healthit.gov/topic/certification-ehrs/enforcement-discretion
      OPTIONAL_PROFILES = {
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sexual-orientation' => ['v610', 'v700'],
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation' => ['v610', 'v700']
      }.freeze

      NON_USCDI_RESOURCES = {
        'Encounter' => ['v311', 'v400'],
        'Location' => ['v311', 'v400', 'v501', 'v610'],
        'Organization' => ['v311', 'v400', 'v501', 'v610', 'v700'],
        'Practitioner' => ['v311', 'v400', 'v501', 'v610', 'v700'],
        'PractitionerRole' => ['v311', 'v400', 'v501', 'v610', 'v700'],
        'Provenance' => ['v311', 'v400', 'v501', 'v610', 'v700'],
        'RelatedPerson' => ['v501', 'v610', 'v700']
      }.freeze

      SEARCHABLE_DELAYED_RESOURCES = {
        'Location' => ['v700']
      }.freeze

      ALL_VERSION_CATEGORY_FIRST_PROFILES = [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-result',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-test',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-imaging',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-screening-assessment',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sdoh-assessment',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-social-history',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-survey',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation'
      ].freeze

      VERSION_SPECIFIC_CATEGORY_FIRST_PROFILES = {
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis' => ['v610', 'v700'],
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns' => ['v610', 'v700']
      }.freeze

      class << self
        def exclude_group?(group)
          RESOURCES_TO_EXCLUDE.key?(group.resource) &&
            RESOURCES_TO_EXCLUDE[group.resource].include?(group.reformatted_version)
        end
      end
    end
  end
end
