module USCoreTestKit
  module InterpreterRequiredExtensionTest
    def scratch_patient_resources
      scratch[:patient_resources] ||= {}
    end

    def scratch_encounter_resources
      scratch[:encounter_resources] ||= {}
    end

    def interpreter_required_extension_url
      'http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed'
    end

    def patient_encounter_resource(encounter_resources, patient_id)
      encounter_resources.select do |encounter|
        encounter.subject.reference.end_with?("Patient/#{patient_id}")
      end
    end

    def encounter_interpreter_required_extension_exists?(encounter_resource)
      encounter_resource.extension.present? && encounter_resource.extension.any? do |extension|
        extension.url == interpreter_required_extension_url
      end
    end

    def verify_interpreter_required_extension_exists
      patient_resources = scratch_patient_resources[:all]
      encounter_resources = scratch_encounter_resources[:all]
      extension_found = false

      patient_resources.each do |patient|
        if patient.extension.present? && patient.extension.any? do |extension|
          extension.url == interpreter_required_extension_url
        end
          extension_found = true
          break
        end

        patient_encounters = patient_encounter_resource(encounter_resources, patient.id)
        next unless patient_encounters.any? do |encounter_resource|
          encounter_interpreter_required_extension_exists?(encounter_resource)
        end

        extension_found = true
        break
      end

      assert(extension_found, %(
        A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one of the US
        Core Patient or US Core Encounter Profiles, but the extension was not found on either profile.
      ))
    end
  end
end
