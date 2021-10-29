require_relative 'naming'

module USCore
  class Generator
    class ReadTestGenerator
      attr_accessor :group_metadata

      class << self
        def generate(ig_metadata)
          ig_metadata.groups
            .select { |group| read_interaction(group).present? }
            .each { |group| new(group).generate }
        end

        def read_interaction(group_metadata)
          group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
        end
      end

      def initialize(group_metadata)
        self.group_metadata = group_metadata
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'read.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def output_file_name
        File.join(__dir__, '..', 'generated', "#{class_name.underscore}.rb")
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

      def conformance_expectation
        read_interaction[:expectation]
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
      end
    end
  end
end
