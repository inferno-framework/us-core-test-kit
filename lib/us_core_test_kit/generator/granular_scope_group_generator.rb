require_relative 'naming'
require_relative '../custom_groups/smart_scopes_constants'

module USCoreTestKit
  class Generator
    class GranularScopeGroupGenerator
      include SmartScopesConstants

      class << self
        def generate(ig_metadata, base_output_dir)
          return unless ['6', '7'].include? ig_metadata.ig_version[1]

          [1, 2].each do |group_number|
            scopes =
              SmartScopesConstants
                .const_get("SMART_GRANULAR_SCOPES_GROUP#{group_number}")[ig_metadata.reformatted_version]
            next if scopes.blank?

            new(ig_metadata, base_output_dir, group_number).generate
          end
        end
      end

      attr_accessor :ig_metadata, :base_output_dir, :group_number

      def initialize(ig_metadata, base_output_dir, group_number)
        self.ig_metadata = ig_metadata
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
        "GranularScopes#{group_number}Group"
      end

      def module_name
        "USCore#{ig_metadata.reformatted_version.upcase}"
      end

      def title
        "#US Core FHIR API w/Granular Scopes #{group_number}"
      end

      def short_description
        # TODO
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def group_dir
        File.join(base_output_dir, 'granular_scope_tests')
      end

      def group_id
        "us_core_#{ig_metadata.reformatted_version}_smart_granular_scopes_#{group_number}"
      end

      def generate
        FileUtils.mkdir_p(group_dir)
        File.open(output_file_name, 'w') { |f| f.write(output) }
        ig_metadata.granular_scope_groups <<
          {
            id: group_id,
            file_name: base_output_file_name
          }
      end

      def group_id_list
        @group_id_list ||=
          ig_metadata
            .granular_scope_resource_type_groups
            .values
            .flatten
            .map { |group| group[:id] }
            .select { |id| id.include? "scope_#{group_number}" }
      end

      def group_file_list
        @group_file_list ||=
          ig_metadata.granular_scope_resource_type_groups
            .values
            .flatten
            .select { |group| group[:file_name].include? "scope#{group_number}" }
            .map do |group|
              name_without_suffix = group[:file_name].delete_suffix('.rb')
              "./#{name_without_suffix}"
            end
      end

      def search_param_name_string
        required_searches
          .map { |search| search[:names].join(' + ') }
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def scopes_string
        SmartScopesConstants.const_get("SMART_GRANULAR_SCOPES_GROUP#{group_number}")
          .dig(ig_metadata.reformatted_version)
          .map { |scope| scope.delete_prefix 'patient/' }
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
