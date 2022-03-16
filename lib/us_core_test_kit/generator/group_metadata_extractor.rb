require_relative 'group_metadata'
require_relative 'ig_metadata'
require_relative 'must_support_metadata_extractor'
require_relative 'search_metadata_extractor'
require_relative 'terminology_binding_metadata_extractor'

module USCoreTestKit
  class Generator
    class GroupMetadataExtractor
      attr_accessor :resource_capabilities, :profile_url, :ig_metadata, :ig_resources

      def initialize(resource_capabilities, profile_url, ig_metadata, ig_resources)
        self.resource_capabilities = resource_capabilities
        self.profile_url = profile_url
        self.ig_metadata = ig_metadata
        self.ig_resources = ig_resources
      end

      def group_metadata
        @group_metadata ||=
          GroupMetadata.new(group_metadata_hash)
      end

      def group_metadata_hash
        @group_metadata_hash ||=
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
            short_description: short_description,
            interactions: interactions,
            operations: operations,
            searches: searches,
            search_definitions: search_definitions,
            include_params: include_params,
            revincludes: revincludes,
            required_concepts: required_concepts,
            must_supports: must_supports,
            mandatory_elements: mandatory_elements,
            bindings: bindings,
            references: references
            # tests: []
          }

        mark_mandatory_and_must_support_searches
        handle_special_cases

        @group_metadata_hash
      end

      def mark_mandatory_and_must_support_searches
        searches.each do |search|
          search[:names_not_must_support_or_mandatory] = search[:names].reject do |name|
            full_path = search_definitions[name.to_sym][:full_path]
            any_must_support_elements = (must_supports[:elements]).any? do |element|
              full_must_support_path = ["#{resource}.#{element[:original_path]}", "#{resource}.#{element[:path]}"]

              full_path.any? do |path|
                # allow for non-choice, choice types, and _id
                name == '_id' || full_must_support_path.include?(path) || full_must_support_path.include?("#{path}[x]")
              end
            end

            any_must_support_slices = must_supports[:slices].any? do |slice|
              # only handle type slices because that is all we need for now
              if slice[:discriminator] && slice[:discriminator][:type] == 'type'
                full_must_support_path = "#{resource}.#{slice[:path].sub('[x]', slice[:discriminator][:code])}"
                full_path.include?(full_must_support_path)
              else
                false
              end
            end

            any_mandatory_elements = mandatory_elements.any? do |element|
              full_path.include?(element)
            end

            any_must_support_elements || any_must_support_slices || any_mandatory_elements
          end

          search[:must_support_or_mandatory] = search[:names_not_must_support_or_mandatory].empty?
        end
      end

      ### BEGIN SPECIAL CASES ###

      CATEGORY_FIRST_PROFILES = [
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab',
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note'
      ]

      def category_first_profile?
        CATEGORY_FIRST_PROFILES.include?(profile_url)
      end

      def first_search_params
        @first_search_params ||=
        if category_first_profile?
          ['patient', 'category']
        elsif resource == 'Observation'
          ['patient', 'code']
        elsif resource == 'MedicationRequest'
          ['patient', 'intent']
        else
          ['patient']
        end
      end

      def handle_special_cases
        set_first_search

        case profile_url
        when 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device'
          must_supports[:elements].delete_if do |element|
            ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'].include? element[:path]
          end
        when 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference'
          must_supports[:elements].delete_if do |element|
            ['content.attachment.data', 'content.attachment.url'].include? element[:path]
          end
        end
      end

      def set_first_search
        search = searches.find { |param| param[:names] == first_search_params }
        return if search.nil?

        searches.delete(search)
        searches.unshift(search)
      end

      ### END SPECIAL CASES ###

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
        profile.title.gsub('  ', ' ')
      end

      def title
        profile.title.gsub(/US\s*Core\s*/, '').gsub(/\s*Profile/, '').strip
      end

      def short_description
        "Verify support for the server capabilities required by the #{profile_name}."
      end

      def interactions
        @interactions ||=
          resource_capabilities.interaction.map do |interaction|
            {
              code: interaction.code,
              expectation: interaction.extension.first.valueCode # TODO: fix expectation extension finding
            }
          end
      end

      def operations
        @operations ||=
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

      def searches
        @searches ||= search_metadata_extractor.searches
      end

      def search_definitions
        @search_definitions ||= search_metadata_extractor.search_definitions
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
        return [] if resource == 'Observation'

        profile_elements
          .select { |element| element.type&.any? { |type| type.code == 'CodeableConcept' } }
          .select { |element| element.binding&.strength == 'required' }
          .map { |element| element.path.gsub("#{resource}.", '').gsub('[x]', 'CodeableConcept') }
      end

      def terminology_binding_metadata_extractor
        @terminology_binding_metadata_extractor ||=
          TerminologyBindingMetadataExtractor.new(profile_elements, ig_resources, resource)
      end

      def bindings
        @bindings ||=
          terminology_binding_metadata_extractor.terminology_bindings
      end

      def must_support_metadata_extractor
        @must_support_metadata_extractor ||=
          MustSupportMetadataExtractor.new(profile_elements, profile, resource)
      end

      def must_supports
        @must_supports ||=
          must_support_metadata_extractor.must_supports
      end

      def mandatory_elements
        @mandatory_elements ||=
          profile_elements
            .select { |element| element.min.positive? }
            .map { |element| element.path }
            .uniq
      end

      def references
        @references ||=
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
