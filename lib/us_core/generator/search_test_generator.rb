require_relative 'naming'

module USCore
  class Generator
    class SearchTestGenerator
      class << self
        def generate(ig_metadata)
          ig_metadata.groups
            .select { |group| group.searches.present? }
            .each do |group|
              group.searches.each { |search| new(group, search).generate }
            end
        end
      end

      attr_accessor :group_metadata, :search_metadata

      def initialize(group_metadata, search_metadata)
        self.group_metadata = group_metadata
        self.search_metadata = search_metadata
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'search.rb.erb'))
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

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "#{profile_identifier}_#{search_identifier}_search_test"
      end

      def search_identifier
        search_metadata[:names].join('_').tr('-', '_')
      end

      def search_title
        search_identifier.camelize
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}#{search_title}SearchTest"
      end

      def resource_type
        group_metadata.resource
      end

      def conformance_expectation
        search_metadata[:expectation]
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
        search_metadata[:names].include? 'patient'
      end

      def search_param_strings
        search_params
          .map { |param| search_param_string(param) }
          .join(",\n")
      end

      def path_for_value(path)
        path == 'class' ? 'local_class' : path
      end

      def search_param_string(param)
        value_string =
          if param[:name] == 'patient'
            'patient_id'
          else
            "search_param_value('#{path_for_value(param[:path])}')"
          end

        "#{' ' * 8}'#{param[:name]}': #{value_string}"
      end

      def search_definition(name)
        group_metadata.search_definitions[name.to_sym]
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
