require_relative 'ig_metadata'

module USCore
  class Generator
    class GroupMetadataExtractor
      attr_accessor :resource, :profile_url, :ig_metadata, :ig_resources

      def initialize(resource, profile_url, ig_metadata, ig_resources)
        self.resource = resource
        self.profile_url = profile_url
        self.ig_metadata = ig_metadata
        self.ig_resources = ig_resources
      end

      def extract
        add_basic_searches
        add_combo_searches
      end

      def group_metadata
        @group_metadata ||=
          {
            name: base_name.tr('-', '_'),
            class_name: class_name,
            version: ig_metadata.ig_version,
            reformatted_version: ig_metadata.reformatted_version,
            # test_id_prefix: test_id_prefix,
            resource: resource.type,
            profile: profile_url,
            profile_name: profile.title,
            title: title,
            # interactions: [],
            # operations: [],
            searches: [],
            search_param_descriptions: {},
            # references: [],
            # must_supports: {
            #   extensions: [],
            #   slices: [],
            #   elements: []
            # },
            # mandatory_elements: [],
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

      def title
        profile.title.gsub(/US\s*Core\s*/, '').gsub(/\s*Profile/, '').strip
      end

      def add_basic_searches
        resource.searchParam&.each do |search_param|
          group_metadata[:searches] << {
            names: [search_param.name],
            expectation: search_param.extension.first.valueCode
          }
          group_metadata[:search_param_descriptions][search_param.name.to_sym] = {}
        end
      end

      def add_combo_searches
        search_extensions = resource.extension || []
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
    end
  end
end
