require_relative 'naming'
require_relative 'special_cases'
require_relative '../custom_groups/smart_scopes_constants'

module USCoreTestKit
  class Generator
    class GranularScopeGroupGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          return unless ['6', '7'].include? ig_metadata.ig_version[1]

          [1, 2].each do |group_number|
            groups = ig_metadata.groups.select { |group| group.granular_scope_tests.present? }

            groups.each do |group_metadata|
              new(GroupMetadata.new(group_metadata.to_hash), base_output_dir, group_number).generate
            end
          end
        end
      end

      attr_accessor :group_metadata, :base_output_dir, :group_number

      def initialize(group_metadata, base_output_dir, group_number)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
        self.group_number = group_number
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'granular_scope_group.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def base_metadata_file_name
        "metadata.yml"
      end

      def class_name
        "#{resource_type}GranularScope#{group_number}Group"
      end

      def module_name
        "USCore#{group_metadata.reformatted_version.upcase}"
      end

      def title
        "#{resource_type} Granular Scope Tests"
      end

      def short_description
        group_metadata.short_description
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def metadata_file_name
        File.join(base_output_dir, profile_identifier, base_metadata_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        "us_core_#{group_metadata.reformatted_version}_#{resource_type.underscore}_granular_scope_#{group_number}_group"
      end

      def resource_type
        group_metadata.resource
      end

      def search_validation_resource_type
        text = "#{resource_type} resources"
        if resource_type == 'Condition' && group_metadata.reformatted_version == 'v501'
          case profile_url
          when 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis'
            text.concat(' with category `encounter-diagnosis`')
          when 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns'
            text.concat(' with category `problem-list-item | health-concern`')
          end
        end

        text
      end

      def profile_name
        group_metadata.profile_name
      end

      def profile_url
        group_metadata.profile_url
      end


      def optional?
        resource_type == 'QuestionnaireResponse' ||
        profile_url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation'
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
        group_metadata.id = group_id
        group_metadata.file_name = base_output_file_name
        File.open(metadata_file_name, 'w') { |f| f.write(YAML.dump(group_metadata.to_hash)) }
      end

      def test_id_list
        @test_id_list ||=
          group_metadata.granular_scope_tests.map { |test| test[:id] }
      end

      def test_file_list
        @test_file_list ||=
          group_metadata.granular_scope_tests.map do |test|
            name_without_suffix = test[:file_name].delete_suffix('.rb')
            name_without_suffix.start_with?('..') ? name_without_suffix : "#{profile_identifier}/#{name_without_suffix}"
          end
      end

      def required_searches
        group_metadata.searches.select { |search| search[:expectation] == 'SHALL' }
      end

      def search_param_name_string
        required_searches
          .map { |search| search[:names].join(' + ') }
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def scopes_string
        SmartScopesConstants.const_get("SMART_GRANULAR_SCOPES_GROUP#{group_number}")
          .map { |scope| scope.delete_prefix 'patient/' }
          .select { |scope| scope.start_with? resource_type }
          .map { |scope| "* `#{scope}`" }
          .join("\n")
      end

      def description
        <<~DESCRIPTION
          The tests in this group repeat all of the searches from the US Core
          FHIR API tests, and verify that the resources returned are filtered
          based on the following granular scopes:

          #{scopes_string}
        DESCRIPTION
      end
    end
  end
end
