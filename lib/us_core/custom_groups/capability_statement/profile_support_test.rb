module USCore
  class ProfileSupportTest < Inferno::Test
    id :us_core_311_profile_support
    title 'Capability Statement lists support for required US Core Profiles'
    description %(
      The US Core Implementation Guide states:

      ```
      The US Core Server SHALL:
      1. Support the US Core Patient resource profile.
      2. Support at least one additional resource profile from the list of US
          Core Profiles.
      ```
    )
    uses_request :capability_statement

    PROFILES = {
      'AllergyIntolerance' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance'].freeze,
      'CarePlan' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan'].freeze,
      'CareTeam' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam'].freeze,
      'Condition' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition'].freeze,
      'Device' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device'].freeze,
      'DiagnosticReport' => [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note'
      ].freeze,
      'DocumentReference' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference'].freeze,
      'Encounter' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter'].freeze,
      'Goal' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal'].freeze,
      'Immunization' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization'].freeze,
      'Location' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-location'].freeze,
      'Medication' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication'].freeze,
      'MedicationRequest' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest'].freeze,
      'Observation' => [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age',
        'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus',
        'http://hl7.org/fhir/StructureDefinition/bp',
        'http://hl7.org/fhir/StructureDefinition/bodyheight',
        'http://hl7.org/fhir/StructureDefinition/bodyweight',
        'http://hl7.org/fhir/StructureDefinition/heartrate',
        'http://hl7.org/fhir/StructureDefinition/resprate',
        'http://hl7.org/fhir/StructureDefinition/bodytemp',
        'http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile'
      ].freeze,
      'Organization' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'].freeze,
      'Patient' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'].freeze,
      'Practitioner' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner'].freeze,
      'PractitionerRole' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'].freeze,
      'Procedure' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure'].freeze,
      'Provenance' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance'].freeze
    }.freeze

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_resources =
        capability_statement.rest
          &.each_with_object([]) do |rest, resources|
            rest.resource.each { |resource| resources << resource.type }
          end.uniq
      supported_profiles =
        capability_statement.rest
          &.flat_map(&:resource)
          &.flat_map { |resource| resource.supportedProfile + [resource.profile] }
          &.compact || []
      supported_profiles.map! { |profile_url| profile_url.split('|').first }

      assert supported_resources.include?('Patient'), 'US Core Patient profile not supported'

      other_resources = PROFILES.keys.reject { |resource_type| resource_type == 'Patient' }
      other_resources_supported = other_resources.any? { |resource| supported_resources.include? resource }
      assert other_resources_supported, 'No US Core resources other than Patient are supported'

      PROFILES.each do |resource_type, profiles|
        next unless supported_resources.include? resource_type

        profiles.each do |profile|
          warning do
            assert supported_profiles&.include?(profile),
                    "CapabilityStatement does not claim support for US Core #{resource_type} profile: #{profile}"
          end
        end
      end
    end
  end
end
