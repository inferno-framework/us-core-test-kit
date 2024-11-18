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

      def version_specific_message_filters
        case ig_metadata.reformatted_version
        when 'v610'
          [
            %r{Observation\.effective\.ofType\(Period\):.*http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus|6.1.0},
            %r{Observation: Slice 'Observation\.effective\[x\]:effectiveDateTime':.*http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus|6.1.0},
            %r{Observation\.effective\.ofType\(Period\)\.(start|end): This element is not allowed by the profile http://hl7.org/fhir/StructureDefinition/dateTime}
          ]
        else
          []
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        'us_core_test_suite.rb'
      end

      def class_name
        'USCoreTestSuite'
      end

      def module_name
        "USCore#{ig_metadata.reformatted_version.upcase}"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        "us_core_#{ig_metadata.reformatted_version}"
      end

      def fhir_api_group_id
        "us_core_#{ig_metadata.reformatted_version}_fhir_api"
      end

      def title
        "US Core #{ig_metadata.ig_version}"
      end

      def ig_identifier
        version = ig_metadata.ig_version[1..] # Remove leading 'v'
        "hl7.fhir.us.core##{version}"
      end

      def ig_link
        Naming.ig_link(ig_metadata.ig_version)
      end

      def us_core_6_and_above?
        ig_metadata.ig_version[1].to_i > 5
      end

      def us_core_7_and_above?
        ig_metadata.ig_version[1].to_i > 6
      end

      def generate
        File.write(output_file_name, output)
      end

      def groups
        ig_metadata.ordered_groups
          .reject { |group| SpecialCases.exclude_group? group }
      end

      def group_id_list
        @group_id_list ||=
          groups.map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.map { |group| group.file_name.delete_suffix('.rb') }
      end

      def capability_statement_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/capability_statement_group"
      end

      def capability_statement_group_id
        "us_core_#{ig_metadata.reformatted_version}_capability_statement"
      end

      def clinical_notes_guidance_file_name
        if ig_metadata.ig_version == 'v3.1.1'
          "../../custom_groups/#{ig_metadata.ig_version}/clinical_notes_guidance_group"
        else
          '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
        end
      end

      def clinical_notes_guidance_group_id
        if ig_metadata.reformatted_version == 'v311'
          "us_core_#{ig_metadata.reformatted_version}_clinical_notes_guidance"
        else
          'us_core_v400_clinical_notes_guidance'
        end
      end

      def granular_scopes_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/smart_granular_scopes_group"
      end

      def granular_scopes_id
        "us_core_#{ig_metadata.reformatted_version}_smart_granular_scopes"
      end

      def screening_assessment_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/screening_assessment_group"
      end

      def screening_assessment_id
        "us_core_#{ig_metadata.reformatted_version}_screening_assessment"
      end

      def smart_app_launch_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/smart_app_launch_group"
      end

      def stu2_2_smart_app_launch_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/smart_app_launch_stu2_2_group"
      end

      def smart_app_launch_id
        if us_core_7_and_above?
          "us_core_#{ig_metadata.reformatted_version}_smart_app_launch"
        else
          'us_core_smart_app_launch'
        end
      end
    end
  end
end
