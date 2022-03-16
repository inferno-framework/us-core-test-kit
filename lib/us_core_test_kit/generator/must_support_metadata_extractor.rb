module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractor
      attr_accessor :profile_elements, :profile, :resource

      def initialize(profile_elements, profile, resource)
        self.profile_elements = profile_elements
        self.profile = profile
        self.resource = resource
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

      def is_vital_sign?
        [
          'http://hl7.org/fhir/StructureDefinition/vitalsigns', 
          'http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs'
        ].include?(profile.baseDefinition)
      end

      def is_blood_pressure?
        ['observation-bp', 'USCoreBloodPressureProfile'].include?(profile.name)
      end

      # exclude component from vital sign profiles except observation-bp and observation-pulse-ox
      def vital_signs_component?(element)
        is_vital_sign? && 
        !is_blood_pressure? && 
        profile.name != 'USCorePulseOximetryProfile' && 
        element.path.include?('component')
      end

      def blood_pressure_value?(element)
        is_blood_pressure? && element.path.include?('Observation.value[x]')
      end

      # ONC clarified that health IT developers that always provide HL7 FHIR "observation" values
      # are not required to demonstrate Health IT Module support for "dataAbsentReason" elements.
      # Remove MS check for dataAbsentReason and component.dataAbsentReason from vital sign profiles      
      def data_absent_reason?(element)
        profile.type == 'Observation' && 
        ['Observation.dataAbsentReason', 'Observation.component.dataAbsentReason'].include?(element.path)
      end

      def all_must_support_elements
        profile_elements
          .select { |element| element.mustSupport }
          .reject do |element|
            # TODO: Can special cases be moved out of here?
            vital_signs_component?(element) || 
            blood_pressure_value?(element) || 
            data_absent_reason?(element)
          end
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

              binding.pry if fixed_element.nil?
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
        ['Reference'].include?(type.code)
      end

      def get_type_must_support_metadata(current_metadata, current_element)
        type_must_support_metadata = []

        current_element.type.each do |type| 
          if type_must_support_extension?(type.extension) 

            metadata =
            {
              path: "#{current_metadata[:path].delete_suffix('[x]')}#{type.code.upcase_first}",
              original_path: current_metadata[:path]
            }

            metadata[:type] = [type.code] if save_type_code?(type)

            handle_type_must_support_target_profile(type, metadata) if type.code == 'Reference'

            type_must_support_metadata << metadata
          end
        end

        type_must_support_metadata
      end

      def handle_type_must_support_target_profile(type, metadata)
        index = 0
        target_profile = []

        type.source_hash['_targetProfile']&.each do |hash|
          element = FHIR::Element.new(hash)
          target_profile << type.targetProfile[index] if type_must_support_extension?(element.extension)
          index += 1
        end

        metadata[:target_profile] = target_profile if target_profile.present?
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
            #path = current_element.path.gsub("#{resource}.", '')
            #current_metadata[:path] = path

            type_must_support_metadata = get_type_must_support_metadata(current_metadata, current_element)

            if type_must_support_metadata.any?
              must_support_elements_metadata.concat(type_must_support_metadata)
            else
              handle_choice_type_in_sliced_element(current_metadata, must_support_elements_metadata)

              supported_type = current_element.type.select { |type| save_type_code?(type) }.map { |type| type.code }             
              current_metadata[:type] = supported_type if supported_type.present?
              #current_metadata[:type] = current_element.type.map { |type| type.code }  
              
              handle_type_must_support_target_profile(current_element.type.first, current_metadata) if current_element.type.first.code == 'Reference'

              handle_fixed_values(current_metadata, current_element)

              must_support_elements_metadata.delete_if do |metadata|
                metadata[:path] == current_metadata[:path] && metadata[:fixed_value].blank?
              end

              must_support_elements_metadata << current_metadata
            end
          end
        end.uniq
      end

      def handle_special_cases
        add_device_distinct_identifier
        add_patient_uscdi_elements
      end

      def add_device_distinct_identifier
        if profile.version == '4.0.0' && profile.type == 'Device'
          # FHIR-36303 US Core 4.0.0 mistakenly removed MS from Device.distinctIdentifier
          # This will be fixed in US Core 5.0.0
          @must_supports[:elements] << {
            path: 'distinctIdentifier'
          }
        end
      end

      def add_patient_uscdi_elements
        if profile.version != '3.1.1' && profile.type == 'Patient'
          #US Core 4.0.0 Section 10.112.1.1 Additional USCDI v1 Requirement:
          @must_supports[:extensions] << {
            id: 'Patient.extension:race',
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
          }
          @must_supports[:extensions] << {
            id: 'Patient.extension:ethnicity',
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
          }
          @must_supports[:extensions] << {
            id: 'Patient.extension:birthsex',
            url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
          }
          @must_supports[:elements] << {
            path: 'telecom'
          }
          @must_supports[:elements] << {
            path: 'name.suffix'
          }
          @must_supports[:elements] << {
            path: 'name.use',
            fixed_value: 'old'
          }
        end
      end
    end
  end
end
