require_relative 'ig_metadata'
require_relative 'must_support_metadata_extractor'
require_relative 'search_metadata_extractor'
require_relative 'terminology_binding_metadata_extractor'

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
        # add_must_support_elements
        # NOTE: binding code can stand alone
        # add_terminology_bindings
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
            must_supports: must_supports,
            mandatory_elements: mandatory_elements,
            bindings: bindings,
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

      def terminology_binding_metadata_extractor
        @terminology_binding_metadata_extractor ||=
          TerminologyBindingMetadataExtractor.new(profile_elements, ig_resources, resource)
      end

      def bindings
        terminology_binding_metadata_extractor.terminology_bindings
      end

      def must_support_metadata_extractor
        @must_support_metadata_extractor ||=
          MustSupportMetadataExtractor.new(profile_elements, profile, resource)
      end

      def must_supports
        must_support_metadata_extractor.must_supports
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
