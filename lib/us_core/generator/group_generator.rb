require_relative 'naming'

module USCore
  class Generator
    class GroupGenerator
      class << self
        def generate(ig_metadata)
          ig_metadata.groups
            .each { |group| new(group).generate }
        end
      end

      attr_accessor :group_metadata

      def initialize(group_metadata)
        self.group_metadata = group_metadata
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'group.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
      end

      def output_file_name
        File.join(__dir__, '..', 'generated', base_output_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        profile_identifier
      end

      def resource_type
        group_metadata.resource
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
        group_metadata.id = group_id
        group_metadata.file_name = base_output_file_name
      end

      def test_id_list
        @test_id_list ||=
          group_metadata.tests.map { |test| test[:id] }
      end

      def test_file_list
        @test_file_list ||=
          group_metadata.tests.map { |test| test[:file_name].delete_suffix('.rb') }
      end
    end
  end
end
