require_relative 'naming'
require_relative 'special_cases'

module USCore
  class Generator
    class ReadTestGenerator
      class << self
        def generate(ig_metadata)
          ig_metadata.groups
            .reject { |group| SpecialCases.exclude_resource? group.resource }
            .select { |group| read_interaction(group).present? }
            .each { |group| new(group).generate }
        end

        def read_interaction(group_metadata)
          group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
        end
      end

      attr_accessor :group_metadata

      def initialize(group_metadata)
        self.group_metadata = group_metadata
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'read.rb.erb'))
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
        "#{profile_identifier}_read_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}ReadTest"
      end

      def resource_type
        group_metadata.resource
      end

      def resource_collection_string
        if group_metadata.delayed? && resource_type != 'Provenance'
          "scratch.dig(:references, '#{resource_type}')"
        else
          'all_scratch_resources'
        end
      end

      def conformance_expectation
        read_interaction[:expectation]
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
