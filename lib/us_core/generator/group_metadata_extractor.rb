require_relative 'ig_metadata'

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
        add_basic_searches
        add_combo_searches
        # add_interactions
        # add_include_search
        # add_revinclude_targets

        # add_required_codeable_concepts
        add_must_support_elements
        # NOTE: binding code can stand alone
        add_terminology_bindings
        add_search_param_descriptions
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
            searches: [],
            search_param_descriptions: {},
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

      def add_basic_searches
        resource_capabilities.searchParam&.each do |search_param|
          group_metadata[:searches] << {
            names: [search_param.name],
            expectation: search_param.extension.first.valueCode # TODO: fix expectation extension finding
          }
          group_metadata[:search_param_descriptions][search_param.name.to_sym] = {}
        end
      end

      def add_combo_searches
        search_extensions = resource_capabilities.extension || []
        combo_extension_url = 'http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination'
        search_extensions
          .select { |extension| extension.url == combo_extension_url }
          .each do |extension|
            combo_params = extension.extension
            new_search_combo = {
              expectation: combo_params.first.valueCode,
              names: []
            }
            combo_params.each do |param|
              next unless param.valueString.present?

              new_search_combo[:names] << param.valueString
              group_metadata[:search_param_descriptions][param.valueString.to_sym] = {}
            end
            group_metadata[:searches] << new_search_combo
          end
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

        profile.snapshot.element
          .select { |element| element.type&.any? { |type| type.code == 'CodeableConcept' } }
          .select { |element| element.binding&.strength == 'required' }
          .map { |element| element.path.gsub("#{resource}.", '').gsub('[x]', 'CodeableConcept') }
      end

      def add_terminology_bindings
        elements = profile.snapshot.element
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
        profile.snapshot.element
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
        elements = profile.snapshot.element
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
        profile.snapshot.element
          .select { |element| element.min.positive? }
          .map { |element| element.path }
      end

      def add_search_param_descriptions
        group_metadata[:search_param_descriptions].each_key do |param_key|
          param = ig_resources.search_param_by_resource_and_name(resource, param_key)
          param_hash = param.source_hash

          path = param.expression.gsub(/.where\((.*)/, '')
          as_type = path.scan(/.as\((.*?)\)/).flatten.first
          path.gsub!(/.as\((.*?)\)/, as_type.upcase_first) if as_type.present?
          element = profile.snapshot.element.find { |element| element.id == path }

          param_metadata = {
            path: path,
            comparators: {},
            values: Set.new
          }
          if element.present?
            param_metadata.merge!(
              type: element.type.first.code,
              contains_multiple: element.max == '*'
            )

            add_valid_codes(element, param_metadata)
          else
            # search is a variable type, eg. Condition.onsetDateTime - element
            # in profile def is Condition.onset[x]
            param_metadata[:type] = param.type
            param_metadata[:contains_multiple] = false
          end

          expectation_extensions = param_hash['_comparator'] || []
          param.comparator&.each_with_index do |comparator, index|
            expectation_extension = expectation_extensions[index]

            expectation =
              if expectation_extension.nil?
                'MAY'
              else
                expectation_extension['extension'].first['valueCode']
              end

            param_metadata[:comparators][comparator.to_sym] = expectation
          end

          multiple_or_expectation = param_hash['_multipleOr']['extension'].first['valueCode']
          param_metadata[:multiple_or] = multiple_or_expectation

          if param.chain.present?
            expectations =
              param_hash['_chain'].map { |expectation| expectation['extension'].first['valueCode'] }
            param_metadata[:chain] =
              param.chain
                .zip(expectations)
                .map { |chain, expectation| { chain: chain, expectation: expectation } }
          end

          group_metadata[:search_param_descriptions][param_key] = param_metadata
        end
      end

      def add_valid_codes(element, param_metadata)
        if param_metadata[:contains_multiple]
          add_values_from_slices(param_metadata)
        elsif param_metadata[:type] == 'CodeableConcept'
          add_values_from_fixed_codes(element, param_metadata)
          add_values_from_pattern_codeable_concept(element, param_metadata)
        end
        add_values_from_value_set_binding(element, param_metadata)
        add_values_from_resource_metadata(param_metadata)
      end

      def add_values_from_slices(param_metadata)
        slices =
          profile.snapshot.element.select do |element|
            element.path == param_metadata[:path] &&
              element.sliceName.present? &&
              element.patternCodeableConcept.present?
          end
        slices.each do |slice|
          param_metadata[:values] << slice.patternCodeableConcept.coding.first.code
        end
      end

      def add_values_from_fixed_codes(profile_element, param_metadata)
        param_metadata[:values] +=
          profile.snapshot.element
            .select { |element| element.path == "#{profile_element.path}.coding.code" && element.fixedCode.present? }
            .map { |element| element.fixedCode }
      end

      def add_values_from_pattern_codeable_concept(profile_element, param_metadata)
        return if profile_element.patternCodeableConcept.blank?

        param_metadata[:values] << profile_element.patternCodeableConcept.coding.first.code
      end

      def add_values_from_value_set_binding(profile_element, param_metadata)
        value_set_binding = profile_element.binding
        return if value_set_binding.blank?

        value_set = ig_resources.value_set_by_url(value_set_binding.valueSet)
        return if value_set.blank?

        systems = value_set.compose.include.reject { |code| code.concept.nil? }
        return if systems.blank?

        param_metadata[:values] += systems.flat_map { |system| system.concept.map { |code| code.code } }
      end

      def add_values_from_resource_metadata(param_metadata)
        fhir_metadata = FHIR.const_get(resource)::METADATA[param_metadata[:path].gsub("#{resource}.", '')]
        use_valid_codes = param_metadata[:values].blank? && fhir_metadata&.dig('valid_codes').present?
        return unless use_valid_codes

        param_metadata[:values] = fhir_metadata['valid_codes'].values.flatten
      end
    end
  end
end
