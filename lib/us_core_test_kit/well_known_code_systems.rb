module USCoreTestKit
  module WellKnownCodeSystems
    HL7_CODE_SYSTEMS = [
      'http://terminology.hl7.org/CodeSystem',
      'http://hl7.org/fhir/us/core/CodeSystem'
    ].freeze

    WELL_KNOWN_CODE_SYSTEMS = [
      'http://loinc.org',
      'http://snomed.info/sct'
    ].freeze

    class << self
      def include?(system)
        return false unless system.present?

        WELL_KNOWN_CODE_SYSTEMS.include?(system) || HL7_CODE_SYSTEMS.any? { |cs| system.start_with?(cs) }
      end
    end
  end
end