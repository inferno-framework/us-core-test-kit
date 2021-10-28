require_relative 'ig_metadata'
require_relative 'search_metadata_extractor'

module USCore
  class Generator
    class GroupMetadataExtractor
      attr_accessor :resource_capabilities, :profile_url, :ig_metadata, :ig_resources

      def initialize(resource_capabilities, profile_url, ig_metadata, ig_resources)
        self.resource_capabilities = resource_capabilities
        self.profile_url = profile_url
        self.ig_metadata = ig_metadata
        self.ig_resources = ig_resources
      end

      def extract
        # add_basic_searches
        # add_combo_searches
        # add_interactions
        # add_include_search
        # add_revinclude_targets

        # add_required_codeable_concepts
        add_must_support_elements
        # NOTE: binding code can stand alone
        add_terminology_bindings
        # add_search_definitions
        add_references

        group_metadata
      end

      def group_metadata
        @group_metadata ||=
          {
            name: name,
            class_name: class_name,
            version: version,
            reformatted_version: reformatted_version,
            # test_id_prefix: test_id_prefix,
            resource: resource,
            profile_url: profile_url,
            profile_name: profile_name,
            title: title,
            interactions: interactions,
            operations: operations,
            searches: search_metadata_extractor.searches,
            search_param_descriptions: search_metadata_extractor.search_definitions,
            include_params: include_params,
            revincludes: revincludes,
            required_concepts: required_concepts,
            # references: [],
            must_supports: {
              extensions: [],
              slices: [],
              elements: []
            },
            mandatory_elements: mandatory_elements,
            # tests: []
          }
      end

      def profile
        @profile ||= ig_resources.profile_by_url(profile_url)
      end

      def profile_elements
        @profile_elements ||= profile.snapshot.element
      end

      def base_name
        profile_url.split('StructureDefinition/').last
      end

      def name
        base_name.tr('-', '_')
      end

      def class_name
        base_name
          .split('-')
          .map(&:capitalize)
          .join
          .gsub('UsCore', "USCore#{ig_metadata.reformatted_version}")
          .concat('Sequence')
      end

      def version
        ig_metadata.ig_version
      end

      def reformatted_version
        ig_metadata.reformatted_version
      end

      def resource
        resource_capabilities.type
      end

      def profile_name
        profile.title
      end

      def title
        profile.title.gsub(/US\s*Core\s*/, '').gsub(/\s*Profile/, '').strip
      end

      def interactions
        resource_capabilities.interaction.map do |interaction|
          {
            code: interaction.code,
            expectation: interaction.extension.first.valueCode # TODO: fix expectation extension finding
          }
        end
      end

      def operations
        resource_capabilities.operation.map do |operation|
          {
            code: operation.name,
            expectation: operation.extension.first.valueCode # TODO: fix expectation extension finding
          }
        end
      end

      def search_metadata_extractor
        @search_metadata_extractor ||=
          SearchMetadataExtractor.new(resource_capabilities, ig_resources, resource, profile_elements)
      end

      def include_params
        resource_capabilities.searchInclude || []
      end

      def revincludes
        resource_capabilities.searchRevInclude || []
      end

      def required_concepts
        # The base FHIR vital signs profile has a required binding that isn't
        # relevant for any of its child profiles
        return if resource == 'Observation'

        profile_elements
          .select { |element| element.type&.any? { |type| type.code == 'CodeableConcept' } }
          .select { |element| element.binding&.strength == 'required' }
          .map { |element| element.path.gsub("#{resource}.", '').gsub('[x]', 'CodeableConcept') }
      end

      def add_terminology_bindings
        elements = profile_elements
        elements_with_bindings =
          elements
            .select { |element| element.binding.present? }
            .reject do |element|
              case element.type.first.code
              when 'Quantity'
                code = elements.find { |e| e.path == "#{element.path}.code" }
                system = elements.find { |e| e.path == "#{element.path}.system" }
                code&.fixedCode || system&.fixedUri
              when 'code'
                element.fixedCode.present?
              end
            end

        group_metadata[:bindings] = elements_with_bindings.map do |element|
          {
            type: element.type.first.code,
            strength: element.binding.strength,
            # Goal.target.detail has an unbound binding
            system: element.binding.valueSet&.split('|')&.first,
            path: element.path.gsub('[x]', '').gsub("#{resource}.", '')
          }
        end

        add_terminology_bindings_from_extensions
        # elements.select { |element| element.type&.first&.code == 'Extension' }
        #   .each { |extension| add_terminology_bindings_from_extension(extension) }
      end

      def add_terminology_bindings_from_extensions
        profile_elements
          .select { |element| element.type&.first&.code == 'Extension' }
          .each do |extension_element|
            extension_url = extension_element.type.first.profile&.first
            next unless extension_url.present?

            extension = ig_resources.profile_by_url(extension_url)

            elements = extension.snapshot.element
            elements_with_bindings = elements.select do |element|
              element.binding.present? && !element.id.include?('Extension.extension')
            end

            group_metadata[:bindings] += elements_with_bindings.map do |element|
              {
                type: element.type.first.code,
                strength: element.binding.strength,
                system: element.binding.valueSet&.split('|')&.first,
                path: element.path.gsub('[x]', '').gsub('Extension.', ''),
                extensions: [extension_url]
              }
            end

            nested_extensions = elements.select { |element| element.path == 'Extension.extension' }
            nested_extensions.each do |nested_extension|
              nested_extension_element = elements.find { |element| element.id == "#{nested_extension.id}.url" }
              next unless nested_extension_element.present?

              nested_extension_url = nested_extension_element.fixedUri
              nested_elements_with_bindings = elements.select do |element|
                element.id.include?(nested_extension.id) && element.binding.present?
              end

              group_metadata[:bindings] += nested_elements_with_bindings.map do |element|
                {
                  type: element.type.first.code,
                  strength: element.binding.strength,
                  system: element.binding.valueSet&.split('|')&.first,
                  path: element.path.gsub('[x]', '').gsub('Extension.extension.', ''),
                  extensions: [extension_url, nested_extension_url]
                }
              end
            end
          end
      end

      def add_must_support_elements
        elements = profile_elements
        elements
          .select { |element| element.mustSupport }
          .each do |current_element|
            # TODO: Can special cases be moved out of here?
            next if profile.baseDefinition == 'http://hl7.org/fhir/StructureDefinition/vitalsigns' &&
                    current_element.path.include?('component')
            next if profile.name == 'observation-bp' && current_element.path.include?('Observation.value[x]')
            next if profile.name.include?('Pediatric') && current_element.path == 'Observation.dataAbsentReason'

            if current_element.path.end_with? 'extension'
              group_metadata[:must_supports][:extensions] << {
                id: current_element.id,
                url: current_element.type.first.profile.first
              }
            elsif current_element.sliceName.present?
              repeated_element = elements.find { |element| element.id == current_element.path  }
              discriminators = repeated_element.slicing.discriminator
              must_support_element = {
                name: current_element.id,
                path: current_element.path.gsub("#{resource}.", '')
              }

              if discriminators.first.type == 'pattern'
                discriminator_path = discriminators.first.path
                discriminator_path = '' if discriminator_path == '$this'
                pattern_element =
                  if discriminator_path.present?
                    elements.find { |element| element.id == "#{current_element.id}.#{discriminator_path}" }
                  else
                    current_element
                  end

                must_support_element[:discriminator] =
                  if pattern_element.patternCodeableConcept.present?
                    {
                      type: 'patternCodeableConcept',
                      path: discriminator_path,
                      code: pattern_element.patternCodeableConcept.coding.first.code,
                      system: pattern_element.patternCodeableConcept.coding.first.system
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
              elsif discriminators.first.type == 'type'
                type_path = discriminators.first.path
                type_path = '' if type_path == '$this'
                type_element =
                  if type_path.present?
                    elements.find { |element| element.id == "#{current_element.id}.#{type_path}" }
                  else
                    current_element
                  end

                type_code = type_element.type.first.code
                must_support_element[:discriminator] = {
                  type: 'type',
                  code: type_code.upcase.first
                }
              elsif discriminators.first.type == 'value'
                must_support_element[:discriminator] = { type: 'value' }
                must_support_element[:discriminator][:values] = discriminators.map do |discriminator|
                  fixed_element = elements.find do |element|
                    element.id.starts_with?(current_element.id) && element.path == "#{current_element.path}.#{discriminator.path}"
                  end

                  {
                    path: discriminator.path,
                    value: fixed_element.fixedUri || fixed_element.fixedCode
                  }
                end
              end
              group_metadata[:must_supports][:slices] << must_support_element
            else
              path = current_element.path.gsub("#{resource}.", '')
              must_support_element = { path: path }
              if current_element.fixedUri.present?
                must_support_element[:fixed_value] = current_element.fixedUri
              elsif current_element.patternCodeableConcept.present?
                must_support_element[:fixed_value] = current_element.patternCodeableConcept.coding.first.code
                must_support_element[:path] += '.coding.code'
              elsif current_element.fixedCode.present?
                must_support_element[:fixed_value] = current_element.fixedCode
              elsif current_element.patternIdentifier.present?
                must_support_element[:fixed_value] = current_element.patternIdentifier.system
                must_support_element[:path] += '.system'
              end
              group_metadata[:must_supports][:elements].delete_if do |must_support|
                must_support[:path] == must_support_element[:path] && must_support[:fixed_value].blank?
              end
              group_metadata[:must_supports][:elements] << must_support_element
            end
          end
        group_metadata[:must_supports][:elements].uniq!
      end

      def mandatory_elements
        profile_elements
          .select { |element| element.min.positive? }
          .map { |element| element.path }
      end

      def add_references
        group_metadata[:references] =
          profile_elements
            .select { |element| element.type&.first&.code == 'Reference' }
            .map do |reference_definition|
              {
                path: reference_definition.path,
                profiles: reference_definition.type.first.targetProfile
              }
            end
      end
    end
  end
end
