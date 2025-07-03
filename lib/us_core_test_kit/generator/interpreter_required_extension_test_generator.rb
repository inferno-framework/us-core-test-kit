module USCoreTestKit
  class Generator
    class InterpreterRequiredExtensionTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .reject { |group| SpecialCases.exclude_group? group }
            .each { |group| new(group, base_output_dir).generate }
        end
      end

      attr_accessor :group_metadata, :base_output_dir

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'interpreter_required_extension_test.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(base_output_dir, profile_identifier)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "us_core_#{group_metadata.reformatted_version}_interpreter_required_extension_test"
      end

      def class_name
        'InterpreterRequiredExtensionTest'
      end

      def module_name
        "USCore#{group_metadata.reformatted_version.upcase}"
      end

      def generate
        return unless group_metadata.resource == 'Encounter' && group_metadata.version[1].to_i > 7

        FileUtils.mkdir_p(output_file_directory)
        File.write(output_file_name, output)

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end
    end
  end
end
