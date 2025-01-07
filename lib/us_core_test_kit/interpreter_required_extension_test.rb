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
      encounter_resources.find do |encounter|
        encounter.subject.reference.end_with?("Patient/#{patient_id}")
      end
    end

    def verify_interpreter_required_extension_exists
      patient_resources = scratch_patient_resources[:all]
      encounter_resources = scratch_encounter_resources[:all]

      patient_resources.each do |patient|
        next if patient.extension.present? && patient.extension.any? do |extension|
          extension.url == interpreter_required_extension_url
        end

        encounter_resource = patient_encounter_resource(encounter_resources, patient.id)
        assert(encounter_resource.present?, %(
          Patient with id #{patient.id} did not include the US Core Interpreter Needed Extension, and no
          Encounter resource for the Patient was found. The extension should be present on an Encounter resource if it
          is not included on the Patient resource.
        ))
        assert(encounter_resource.extension.present? &&
          encounter_resource.extension.any? { |extension| extension.url == interpreter_required_extension_url }, %(
            A certifying Server system SHALL support the US Core Interpreter Needed Extension on at least one of the US
            Core Patient or US Core Encounter Profiles, but the extension was not found on either profile for Patient
            with id #{patient.id}.
          ))
      end
    end
  end
end
