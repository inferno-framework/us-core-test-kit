module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore4
      def self.handle_special_cases(profile, must_supports)
        return unless profile.version == '4.0.0'

        add_must_support_choices(profile, must_supports)
        add_device_distinct_identifier(profile, must_supports)
        add_patient_uscdi_elements(profile, must_supports)
      end

      def self.add_must_support_choices(profile, must_supports)
        choices = []

        choices << { paths: ['content.attachment.data', 'content.attachment.url'] } if profile.type == 'DocumentReference'

        case profile.type
        when 'Encounter'
          choices << { paths: ['reasonCode', 'reasonReference'] }
          choices << { paths: ['location.location', 'serviceProvider'] }
        when 'MedicationRequest'
          choices << { paths: ['reportedBoolean', 'reportedReference'] }
        end

        must_supports[:choices] = choices if choices.present?
      end

      def self.add_device_distinct_identifier(profile, must_supports)
        if profile.type == 'Device'
          # FHIR-36303 US Core 4.0.0 mistakenly removed MS from Device.distinctIdentifier
          # This will be fixed in US Core 5.0.0
          must_supports[:elements] << {
            path: 'distinctIdentifier'
          }
        end
      end

      def self.add_patient_uscdi_elements(profile, must_supports)
        return unless profile.type == 'Patient'

        #US Core 4.0.0 Section 10.112.1.1 Additional USCDI v1 Requirement:
        must_supports[:extensions] << {
          id: 'Patient.extension:race',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
          uscdi_only: true
        }
        must_supports[:extensions] << {
          id: 'Patient.extension:ethnicity',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity',
          uscdi_only: true
        }
        must_supports[:extensions] << {
          id: 'Patient.extension:birthsex',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'name.suffix',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'name.period.end',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'telecom',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'communication',
          uscdi_only: true
        }
        # Though telecom.system, telecom.value, telecom.use, and communication.language are marked as MustSupport since US Core v4.0.0,
        # their parent elements telecom, and communication are not MustSupport but listed under "Additional USCDI requirements"
        # According to the updated FHIR spec that "When a child element is defined as Must Support and the parent element isn't,
        # a system must support the child if it support the parent, but there's no expectation that the system must support the parent.",
        # We add uscdi_only tag to these elements
        must_supports[:elements].each do |element|
          path = element[:path]
          element[:uscdi_only] = true if path.include?('telecom.') || path.include?('communication.')
        end
      end
    end
  end
end