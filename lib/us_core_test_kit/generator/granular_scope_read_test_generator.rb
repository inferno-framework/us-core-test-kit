require_relative 'naming'
require_relative 'special_cases'
require_relative '../custom_groups/smart_scopes_constants'

module USCoreTestKit
  class Generator
    class GranularScopeReadTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)

          return if ig_metadata.ig_version[1].to_i < 6

          scopes =
            SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP1[ig_metadata.reformatted_version] +
            (SmartScopesConstants::SMART_GRANULAR_SCOPES_GROUP2[ig_metadata.reformatted_version] || [])

          SmartScopesConstants::SMART_GRANULAR_SCOPE_RESOURCES.each do |resource_type|
            group = ig_metadata.groups.find { |group| group.resource == resource_type }

            next if scopes.none? { |scope| scope.start_with? "patient/#{group.resource}" }

          new(group, base_output_dir).generate
          end
        end
      end

      attr_accessor :group_metadata, :base_output_dir, :group_number

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'granular_scope_read_test.rb.erb'))
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
        "us_core_#{group_metadata.reformatted_version}_#{resource_type}_granular_scope_read_test"
      end

      def class_name
        "#{resource_type}GranularScopeReadTest"
      end

      def module_name
        "USCore#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def path_for_value(path)
        path == 'class' ? 'local_class' : path
      end

      def array_of_strings(array)
        quoted_strings = array.map { |element| "'#{element}'" }
        "[#{quoted_strings.join(', ')}]"
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
          This test attempts #{resource_type} reads
          and verifies that the results have been
          filtered based on the granted granular scopes.
        DESCRIPTION
      end
    end
  end
end
