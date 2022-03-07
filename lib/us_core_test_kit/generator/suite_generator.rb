require_relative 'naming'
require_relative 'special_cases'

module USCoreTestKit
  class Generator
    class SuiteGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          new(ig_metadata, base_output_dir).generate
        end
      end

      attr_accessor :ig_metadata, :base_output_dir

      def initialize(ig_metadata, base_output_dir)
        self.ig_metadata = ig_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "us_core_test_suite.rb"
      end

      def class_name
        "USCoreTestSuite"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        'us_core_311'
      end

      def title
        'US Core 3.1.1'
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
      end

      def groups
        ig_metadata.ordered_groups
          .reject { |group| SpecialCases.exclude_resource? group.resource }
      end

      def group_id_list
        @group_id_list ||=
          groups.map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.map { |group| group.file_name.delete_suffix('.rb') }
      end
    end
  end
end
