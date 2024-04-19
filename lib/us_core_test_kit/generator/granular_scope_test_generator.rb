require_relative 'naming'
require_relative 'special_cases'
require_relative '../custom_groups/smart_scopes_constants'

module USCoreTestKit
  class Generator
    class GranularScopeTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          return unless ['6', '7'].include? ig_metadata.ig_version[1]

          scopes =
            SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP1[ig_metadata.reformatted_version] +
            (SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP2[ig_metadata.reformatted_version] || [])

          SmartScopesConstants::SMART_GRANULAR_SCOPE_RESOURCES.each do |resource_type|
            group = ig_metadata.groups.find { |group| group.resource == resource_type }

            next if scopes.blank? || scopes.none? { |scope| scope.start_with? "patient/#{group.resource}" }

            group.searches
              .each { |search| new(group, search, base_output_dir).generate }
          end
        end
      end

      attr_accessor :group_metadata, :search_metadata, :base_output_dir, :group_number

      def initialize(group_metadata, search_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.search_metadata = search_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'granular_scope_test.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(base_output_dir, 'granular_scope_tests', resource_type.underscore)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "us_core_#{group_metadata.reformatted_version}_#{resource_type}_#{search_identifier}_granular_scope_test"
      end

      def search_identifier
        search_metadata[:names].join('_').tr('-', '_')
      end

      def search_title
        search_identifier.camelize
      end

      def class_name
        "#{resource_type}#{search_title}GranularScopeTest"
      end

      def module_name
        "USCore#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def search_params
        @search_params ||=
          search_metadata[:names].map do |name|
            {
              name: name,
              path: search_definition(name)[:path]
            }
          end
      end

      def search_param_name_string
        search_metadata[:names].join(' + ')
      end

      def needs_patient_id?
        search_metadata[:names].include?('patient') ||
          (resource_type == 'Patient' && search_metadata[:names].include?('_id'))
      end

      def search_param_names
        search_params.map { |param| param[:name] }
      end

      def search_param_names_array
        array_of_strings(search_param_names)
      end

      def path_for_value(path)
        path == 'class' ? 'local_class' : path
      end

      def search_definition(name)
        group_metadata.search_definitions[name.to_sym]
      end

      def array_of_strings(array)
        quoted_strings = array.map { |element| "'#{element}'" }
        "[#{quoted_strings.join(', ')}]"
      end

      def search_properties
        {}.tap do |properties|
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = search_param_names_array
        end
      end

      def url_version
        case group_metadata.version
        when 'v3.1.1'
          'STU3.1.1'
        when 'v4.0.0'
          'STU4'
        end
      end

      def search_test_properties_string
        search_properties
          .map { |key, value| "#{' ' * 8}#{key}: #{value}" }
          .join(",\n")
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_granular_scope_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end

      def description
        <<~DESCRIPTION.gsub(/\n{3,}/, "\n\n")
          This test repeats all #{resource_type} searches by
          #{search_param_name_string} and verifies that the results have been
          filtered based on the granted granular scopes.
        DESCRIPTION
      end
    end
  end
end
