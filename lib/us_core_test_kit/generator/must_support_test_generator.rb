require_relative 'naming'
require_relative 'special_cases'

module USCore
  class Generator
    class MustSupportTestGenerator
      class << self
        def generate(ig_metadata)
          ig_metadata.groups
            .reject { |group| SpecialCases.exclude_resource? group.resource }
            .each { |group| new(group).generate }
        end
      end

      attr_accessor :group_metadata

      def initialize(group_metadata)
        self.group_metadata = group_metadata
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'must_support.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(__dir__, '..', 'generated', profile_identifier)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def read_interaction
        self.class.read_interaction(group_metadata)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "us_core_311_#{profile_identifier}_must_support_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}MustSupportTest"
      end

      def resource_type
        group_metadata.resource
      end

      def resource_collection_string
        'all_scratch_resources'
      end

      def must_support_list_string
        slice_names = group_metadata.must_supports[:slices].map { |slice| slice[:name] }
        element_names = group_metadata.must_supports[:elements].map { |slice| "#{resource_type}.#{slice[:path]}" }
        extension_names = group_metadata.must_supports[:extensions].map { |slice| slice[:id] }
        (slice_names + element_names + extension_names)
          .sort
          .map { |name| "      * #{name}" }
          .join("\n")
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end
    end
  end
end
