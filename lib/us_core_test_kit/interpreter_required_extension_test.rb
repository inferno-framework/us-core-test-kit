module USCoreTestKit
  module InterpreterRequiredExtensionTest
    def scratch_patient_resources
      scratch[:patient_resources] ||= {}
    end

    def scratch_encounter_resources
      scratch[:encounter_resources] ||= {}
    end

    def scratch_patient_and_encounter_resources
      all_resources = scratch_patient_resources[:all]
      all_resources.push(*scratch_encounter_resources[:all])
      all_resources
    end

    def interpreter_required_extension_url
      'http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed'
    end

    def interpreter_required_extension_exists?(resource)
      resource.extension.present? && resource.extension.any? do |extension|
        extension.url == interpreter_required_extension_url
      end
    end

    def verify_interpreter_required_extension_exists
      patient_and_encounter_resources = scratch_patient_and_encounter_resources

      extension_found = patient_and_encounter_resources.any? do |resource|
        interpreter_required_extension_exists?(resource)
      end

      assert(extension_found, %(
        A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one of the US
        Core Patient or US Core Encounter Profiles, but the extension was not found on either profile.
      ))
    end
  end
end
