module USCoreTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = [
        'Location',
        'Medication',
        'PractitionerRole'
      ].freeze

      PROFILES_TO_EXCLUDE = [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-survey',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs'
      ].freeze

      NON_USCDI_RESOURCES = {
        'Encounter' => ['v311', 'v400'],
        'Location' => ['v311', 'v400', 'v501', 'v610', 'v700_ballot'],
        'Organization' => ['v311', 'v400', 'v501', 'v610', 'v700_ballot'],
        'Practitioner' => ['v311', 'v400'],
        'PractitionerRole' => ['v311', 'v400', 'v501', 'v610', 'v700_ballot'],
        'Provenance' => ['v311', 'v400', 'v501', 'v610', 'v700_ballot'],
        'RelatedPerson' => ['v501', 'v610', 'v700_ballot'],
        'Specimen' => ['v610', 'v700_ballot']
      }.freeze

      SEARCHABLE_DELAYED_RESOURCES = {
        'Practitioner' => ['v501', 'v610', 'v700_ballot']
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
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis' => ['v610', 'v700_ballot'],
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns' => ['v610', 'v700_ballot']
      }.freeze

      class << self
        def exclude_group?(group)
          RESOURCES_TO_EXCLUDE.include?(group.resource)
        end
      end
    end
  end
end
