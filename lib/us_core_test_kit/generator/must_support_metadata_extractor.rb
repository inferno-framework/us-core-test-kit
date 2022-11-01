require_relative 'value_extractor'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractor
      attr_accessor :profile_elements, :profile, :resource, :ig_resources

      def initialize(profile_elements, profile, resource, ig_resources)
        self.profile_elements = profile_elements
        self.profile = profile
        self.resource = resource
        self.ig_resources = ig_resources
      end

      def must_supports
        @must_supports = {
          extensions: must_support_extensions,
          slices: must_support_slices,
          elements: must_support_elements
        }

        handle_special_cases

        @must_supports
      end

      def all_must_support_elements
        profile_elements.select { |element| element.mustSupport }
      end

      def must_support_extension_elements
        all_must_support_elements.select { |element| element.path.end_with? 'extension' }
      end

      def must_support_extensions
        must_support_extension_elements.map do |element|
          {
            id: element.id,
            url: element.type.first.profile.first
          }
        end
      end

      def must_support_slice_elements
        all_must_support_elements.select { |element| !element.path.end_with?('extension') && element.sliceName.present? }
      end

      def sliced_element(slice)
        profile_elements.find { |element| element.id == slice.path }
      end

      def discriminators(slice)
        slice.slicing.discriminator
      end

      def must_support_pattern_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'pattern'
        end
      end

      def pattern_slices
        must_support_pattern_slice_elements.map do |current_element|
          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", '')
          }.tap do |metadata|
            discriminator = discriminators(sliced_element(current_element)).first
            discriminator_path = discriminator.path
            discriminator_path = '' if discriminator_path == '$this'
            pattern_element =
              if discriminator_path.present?
                profile_elements.find { |element| element.id == "#{current_element.id}.#{discriminator_path}" }
              else
                current_element
              end

            metadata[:discriminator] =
              if pattern_element.patternCodeableConcept.present?
                {
                  type: 'patternCodeableConcept',
                  path: discriminator_path,
                  code: pattern_element.patternCodeableConcept.coding.first.code,
                  system: pattern_element.patternCodeableConcept.coding.first.system
                }
              elsif pattern_element.patternCoding.present?
                {
                  type: 'patternCoding',
                  path: discriminator_path,
                  code: pattern_element.patternCoding.code,
                  system: pattern_element.patternCoding.system
                }
              elsif pattern_element.patternIdentifier.present?
                {
                  type: 'patternIdentifier',
                  path: discriminator_path,
                  system: pattern_element.patternIdentifier.system
                }
              elsif pattern_element.binding&.strength == 'required' &&
                    pattern_element.binding&.valueSet.present?

                value_extractor = ValueExactor.new(ig_resources, resource)

                values = value_extractor.values_from_value_set_binding(pattern_element).presence ||
                         value_extractor.values_from_resource_metadata([metadata[:path]]) || []

                {
                  type: 'requiredBinding',
                  path: discriminator_path,
                  values: values
                }
              else
                raise StandardError, 'Unsupported discriminator pattern type'
              end
          end
        end
      end

      def must_support_type_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'type'
        end
      end

      def type_slices
        must_support_type_slice_elements.map do |current_element|
          discriminator = discriminators(sliced_element(current_element)).first
          type_path = discriminator.path
          type_path = '' if type_path == '$this'
          type_element =
            if type_path.present?
              elements.find { |element| element.id == "#{current_element.id}.#{type_path}" }
            else
              current_element
            end

          type_code = type_element.type.first.code

          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'type',
              code: type_code.upcase_first
            }
          }
        end
      end

      def must_support_value_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'value'
        end
      end

      def value_slices
        must_support_value_slice_elements.map do |current_element|
          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'value'
            }
          }.tap do |metadata|
            metadata[:discriminator][:values] = discriminators(sliced_element(current_element)).map do |discriminator|
              fixed_element = profile_elements.find do |element|
                element.id.starts_with?(current_element.id) &&
                  element.path == "#{current_element.path}.#{discriminator.path}"
              end

              {
                path: discriminator.path,
                value: fixed_element.fixedUri || fixed_element.fixedCode
              }
            end
          end
        end
      end

      def must_support_slices
        pattern_slices + type_slices + value_slices
      end

      def plain_must_support_elements
        all_must_support_elements - must_support_extension_elements - must_support_slice_elements
      end

      def handle_fixed_values(metadata, element)
        if element.fixedUri.present?
          metadata[:fixed_value] = element.fixedUri
        elsif element.patternCodeableConcept.present?
          metadata[:fixed_value] = element.patternCodeableConcept.coding.first.code
          metadata[:path] += '.coding.code'
        elsif element.fixedCode.present?
          metadata[:fixed_value] = element.fixedCode
        elsif element.patternIdentifier.present?
          metadata[:fixed_value] = element.patternIdentifier.system
          metadata[:path] += '.system'
        end
      end

      def type_must_support_extension?(extensions)
        extensions&.any? do |extension|
          extension.url == 'http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support' &&
          extension.valueBoolean
        end
      end

      def save_type_code?(type)
        'Reference' == type.code
      end

      def get_type_must_support_metadata(current_metadata, current_element)
        current_element.type.map do |type|
          if type_must_support_extension?(type.extension)
            metadata =
            {
              path: "#{current_metadata[:path].delete_suffix('[x]')}#{type.code.upcase_first}",
              original_path: current_metadata[:path]
            }
            metadata[:type] = [type.code] if save_type_code?(type)
            handle_type_must_support_target_profiles(type, metadata) if type.code == 'Reference'

            metadata
          end
        end.compact
      end

      def handle_type_must_support_target_profiles(type, metadata)
        index = 0
        target_profiles = []

        type.source_hash['_targetProfile']&.each do |hash|
          if hash.present?
            element = FHIR::Element.new(hash)
            target_profiles << type.targetProfile[index] if type_must_support_extension?(element.extension)
          end
          index += 1
        end

        metadata[:target_profiles] = target_profiles if target_profiles.present?
      end

      def handle_choice_type_in_sliced_element(current_metadata, must_support_elements_metadata)
        choice_element_metadata = must_support_elements_metadata.find do |metadata|
          metadata[:original_path].present? &&
          current_metadata[:path].include?( metadata[:original_path] )
        end

        if choice_element_metadata.present?
          current_metadata[:original_path] = current_metadata[:path]
          current_metadata[:path] = current_metadata[:path].sub(choice_element_metadata[:original_path], choice_element_metadata[:path])
        end
      end

      def must_support_elements
        plain_must_support_elements.each_with_object([]) do |current_element, must_support_elements_metadata|
          {
            path: current_element.path.gsub("#{resource}.", '')
          }.tap do |current_metadata|
            type_must_support_metadata = get_type_must_support_metadata(current_metadata, current_element)

            if type_must_support_metadata.any?
              must_support_elements_metadata.concat(type_must_support_metadata)
            else
              handle_choice_type_in_sliced_element(current_metadata, must_support_elements_metadata)

              supported_types = current_element.type.select { |type| save_type_code?(type) }.map { |type| type.code }
              current_metadata[:types] = supported_types if supported_types.present?

              handle_type_must_support_target_profiles(current_element.type.first, current_metadata) if current_element.type.first&.code == 'Reference'

              handle_fixed_values(current_metadata, current_element)

              must_support_elements_metadata.delete_if do |metadata|
                metadata[:path] == current_metadata[:path] && metadata[:fixed_value].blank?
              end

              must_support_elements_metadata << current_metadata
            end
          end
        end.uniq
      end

      #### SPECIAL CASE ####

      def handle_special_cases
        remove_vital_sign_component
        remove_blood_pressure_value
        remove_observation_data_absent_reason
        add_must_support_choices

        case profile.version
        when '4.0.0'
          add_device_distinct_identifier
          add_patient_uscdi_elements
        when '5.0.1'
          add_patient_uscdi_elements
          add_document_reference_category_values
          remove_survey_questionnaire_response
        end
      end

      def is_vital_sign?
        [
          'http://hl7.org/fhir/StructureDefinition/vitalsigns',
          'http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs'
        ].include?(profile.baseDefinition)
      end

      def is_blood_pressure?
        ['observation-bp', 'USCoreBloodPressureProfile'].include?(profile.name)
      end

      # Exclude Observation.component from vital sign profiles except observation-bp and observation-pulse-ox
      def remove_vital_sign_component
        if is_vital_sign? && !is_blood_pressure? && profile.name != 'USCorePulseOximetryProfile'
          @must_supports[:elements].delete_if do |element|
            element[:path].start_with?('component')
          end
        end
      end

      # Exclude Observation.value[x] from observation-bp
      def remove_blood_pressure_value
        if is_blood_pressure?
          @must_supports[:elements].delete_if do |element|
            element[:path].start_with?('value[x]') || element[:original_path]&.start_with?('value[x]')
          end
          @must_supports[:slices].delete_if do |slice|
            slice[:path].start_with?('value[x]')
          end
        end
      end

      # ONC and US Core 4.0.0 both clarified that health IT developers that always provide HL7 FHIR "observation" values
      # are not required to demonstrate Health IT Module support for "dataAbsentReason" elements.
      # Remove MS check for dataAbsentReason and component.dataAbsentReason from vital sign profiles and observation lab profile
      # Smoking status profile does not have MS on dataAbsentReason. It is safe to use profile.type == 'Observation'
      def remove_observation_data_absent_reason
        if profile.type == 'Observation'
          @must_supports[:elements].delete_if do |element|
            ['dataAbsentReason', 'component.dataAbsentReason'].include?(element[:path])
          end
        end
      end

      def remove_device_carrier
        if profile.type == 'Device'
          @must_supports[:elements].delete_if do |element|
            ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'].include?(element[:path])
          end
        end
      end

      def remove_document_reference_attachment_data_url
        if profile.type == 'DocumentReference'
          @must_supports[:elements].delete_if do |element|
            ['content.attachment.data', 'content.attachment.url'].include?(element[:path])
          end
        end
      end

      def add_must_support_choices
        choices = []

        choices << { paths: ['content.attachment.data', 'content.attachment.url'] } if profile.type == 'DocumentReference'

        case profile.version
        when '3.1.1'
          choices << { paths: ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'] } if profile.type == 'Device'
        when '4.0.0'
          case profile.type
          when 'Encounter'
            choices << { paths: ['reasonCode', 'reasonReference'] }
            choices << { paths: ['location.location', 'serviceProvider'] }
          when 'MedicationRequest'
            choices << { paths: ['reportedBoolean', 'reportedReference'] }
          end
        when '5.0.1'
          case profile.type
          when 'CareTeam'
            choices << {
              target_profiles: [
                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner',
                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'
              ]
            }
          when 'Condition'
            choices << {
              paths: ['onsetDateTime'],
              extension_ids: ['Condition.extension:assertedDate']
            }
          when 'Encounter'
            choices << { paths: ['reasonCode', 'reasonReference'] }
            choices << { paths: ['location.location', 'serviceProvider'] }
          when 'MedicationRequest'
            choices << { paths: ['reportedBoolean', 'reportedReference'] }
          end
        end

        @must_supports[:choices] = choices if choices.present?
      end

      def add_device_distinct_identifier
        if profile.type == 'Device'
          # FHIR-36303 US Core 4.0.0 mistakenly removed MS from Device.distinctIdentifier
          # This will be fixed in US Core 5.0.0
          @must_supports[:elements] << {
            path: 'distinctIdentifier'
          }
        end
      end

      def add_patient_uscdi_elements
        return unless profile.type == 'Patient'

        #US Core 4.0.0 Section 10.112.1.1 Additional USCDI v1 Requirement:
        @must_supports[:extensions] << {
          id: 'Patient.extension:race',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
          uscdi_only: true
        }
        @must_supports[:extensions] << {
          id: 'Patient.extension:ethnicity',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity',
          uscdi_only: true
        }
        @must_supports[:extensions] << {
          id: 'Patient.extension:birthsex',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex',
          uscdi_only: true
        }
        @must_supports[:elements] << {
          path: 'name.suffix',
          uscdi_only: true
        }
        @must_supports[:elements] << {
          path: 'name.period.end',
          uscdi_only: true
        }
        @must_supports[:elements] << {
          path: 'telecom',
          uscdi_only: true
        }
        @must_supports[:elements] << {
          path: 'communication',
          uscdi_only: true
        }
        # Though telecom.system, telecom.value, telecom.use, and communication.language are marked as MustSupport since US Core v4.0.0,
        # their parent elements telecom, and communication are not MustSupport but listed under "Additional USCDI requirements"
        # According to the updated FHIR spec that "When a child element is defined as Must Support and the parent element isn't,
        # a system must support the child if it support the parent, but there's no expectation that the system must support the parent.",
        # We add uscdi_only tag to these elements
        @must_supports[:elements].each do |element|
          path = element[:path]
          element[:uscdi_only] = true if path.include?('telecom.') || path.include?('communication.')
        end

        if profile.version == '5.0.1'
          @must_supports[:extensions] << {
            id: 'Patient.extension:genderIdentity',
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity',
            uscdi_only: true
          }
          @must_supports[:elements] << {
            path: 'address.use',
            fixed_value: 'old',
            uscdi_only: true
          }
          @must_supports[:elements] << {
            path: 'name.use',
            fixed_value: 'old',
            uscdi_only: true
          }
        end
      end

      def add_document_reference_category_values
        return unless profile.type == 'DocumentReference'

        slice = @must_supports[:slices].find{|slice| slice[:path] == 'category'}

        slice[:discriminator][:values] = ['clinical-note'] if slice.present?
      end

      # FHIR-37794 Server systems are not required to support US Core QuestionnaireResponse
      def remove_survey_questionnaire_response
        return unless profile.type == 'Observation' &&
          ['us-core-observation-survey', 'us-core-observation-sdoh-assessment'].include?(profile.id)

        element = @must_supports[:elements].find { |element| element[:path] == 'derivedFrom' }
        element[:target_profiles].delete_if do |url|
          url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse'
        end
      end
    end
  end
end
