require_relative 'naming'
require_relative 'special_cases'
require_relative '../custom_groups/smart_scopes_constants'

module USCoreTestKit
  class Generator
    class GranularScopeTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          return unless ['6', '7'].include? ig_metadata.ig_version[1]

          SmartScopesConstants::SMART_GRANULAR_SCOPE_RESOURCES.each do |resource_type|
            # guard that resource_type is in this group

            group = ig_metadata.groups.find { |group| group.resource == resource_type }

            group.searches
              .each { |search| new(group, search, base_output_dir).generate }
          end
        end
      end

      attr_accessor :group_metadata, :search_metadata, :base_output_dir, :group_number

      def initialize(group_metadata, search_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.search_metadata = search_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'granular_scope_test.rb.erb'))
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
        "us_core_#{group_metadata.reformatted_version}_#{resource_type}_#{search_identifier}_granular_scope_test"
      end

      def search_identifier
        search_metadata[:names].join('_').tr('-', '_')
      end

      def search_title
        search_identifier.camelize
      end

      def class_name
        "#{resource_type}#{search_title}GranularScopeTest"
      end

      def module_name
        "USCore#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      # def conformance_expectation
      #   search_metadata[:expectation]
      # end

      def search_params
        @search_params ||=
          search_metadata[:names].map do |name|
            {
              name: name,
              path: search_definition(name)[:path]
            }
          end
      end

      # def first_search?
      #   group_metadata.searches.first == search_metadata
      # end

      # def fixed_value_search?
      #   first_search? && search_metadata[:names] != ['patient'] &&
      #     !group_metadata.delayed? && resource_type != 'Patient'
      # end

      # def fixed_value_search_param_name
      #   (search_metadata[:names] - [:patient]).first
      # end

      def search_param_name_string
        search_metadata[:names].join(' + ')
      end

      def needs_patient_id?
        search_metadata[:names].include?('patient') ||
          (resource_type == 'Patient' && search_metadata[:names].include?('_id'))
      end

      def search_param_names
        search_params.map { |param| param[:name] }
      end

      def search_param_names_array
        array_of_strings(search_param_names)
      end

      def path_for_value(path)
        path == 'class' ? 'local_class' : path
      end

      # def required_comparators_for_param(name)
      #   search_definition(name)[:comparators].select { |_comparator, expectation| expectation == 'SHALL' }
      # end

      # def required_comparators
      #   @required_comparators ||=
      #     search_param_names.each_with_object({}) do |name, comparators|
      #       required_comparators = required_comparators_for_param(name)
      #       comparators[name] = required_comparators if required_comparators.present?
      #     end
      # end

      # def optional?
      #   conformance_expectation != 'SHALL' || !search_metadata[:must_support_or_mandatory]
      # end

      def search_definition(name)
        group_metadata.search_definitions[name.to_sym]
      end

      # def saves_delayed_references?
      #   first_search? && group_metadata.delayed_references.present?
      # end

      # def possible_status_search?
      #   !search_metadata[:names].any? { |name| name.include? 'status' } &&
      #     group_metadata.search_definitions.keys.any? { |key| key.to_s.include? 'status' }
      # end

      # def token_search_params
      #   @token_search_params ||=
      #     search_param_names.select do |name|
      #       ['Identifier', 'CodeableConcept', 'Coding'].include? group_metadata.search_definitions[name.to_sym][:type]
      #     end
      # end

      # def token_search_params_string
      #   array_of_strings(token_search_params)
      # end

      # def required_multiple_or_search_params
      #   @multiple_or_search_params ||=
      #     search_param_names.select do |name|
      #       search_definition(name)[:multiple_or] == 'SHALL'
      #     end
      # end

      # def required_multiple_or_search_params_string
      #   array_of_strings(required_multiple_or_search_params)
      # end

      # def required_comparators_string
      #   array_of_strings(required_comparators.keys)
      # end

      def array_of_strings(array)
        quoted_strings = array.map { |element| "'#{element}'" }
        "[#{quoted_strings.join(', ')}]"
      end

      # def test_reference_variants?
      #   first_search? && search_param_names.include?('patient')
      # end

      # def test_medication_inclusion?
      #   ['MedicationRequest', 'MedicationDispense'].include?(resource_type)
      # end

      # def test_post_search?
      #   first_search?
      # end

      def search_properties
        {}.tap do |properties|
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = search_param_names_array
        end
      end

      def url_version
        case group_metadata.version
        when 'v3.1.1'
          'STU3.1.1'
        when 'v4.0.0'
          'STU4'
        end
      end

      def search_test_properties_string
        search_properties
          .map { |key, value| "#{' ' * 8}#{key}: #{value}" }
          .join(",\n")
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_granular_scope_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end

      # def reference_search_description
      #   return '' unless test_reference_variants?

      #   <<~REFERENCE_SEARCH_DESCRIPTION
      #   This test verifies that the server supports searching by reference using
      #   the form `patient=[id]` as well as `patient=Patient/[id]`. The two
      #   different forms are expected to return the same number of results. US
      #   Core requires that both forms are supported by US Core responders.
      #   REFERENCE_SEARCH_DESCRIPTION
      # end

      # def first_search_description
      #   return '' unless first_search?

      #   <<~FIRST_SEARCH_DESCRIPTION
      #   Because this is the first search of the sequence, resources in the
      #   response will be used for subsequent tests.
      #   FIRST_SEARCH_DESCRIPTION
      # end

      # def medication_inclusion_description
      #   return '' unless test_medication_inclusion?

      #   <<~MEDICATION_INCLUSION_DESCRIPTION
      #   If any #{resource_type} resources use external references to
      #   Medications, the search will be repeated with
      #   `_include=#{resource_type}:medication`.
      #   MEDICATION_INCLUSION_DESCRIPTION
      # end

      # def post_search_description
      #   return '' unless test_post_search?

      #   <<~POST_SEARCH_DESCRIPTION
      #   Additionally, this test will check that GET and POST search methods
      #   return the same number of results. Search by POST is required by the
      #   FHIR R4 specification, and these tests interpret search by GET as a
      #   requirement of US Core #{group_metadata.version}.
      #   POST_SEARCH_DESCRIPTION
      # end

      def description
        <<~DESCRIPTION.gsub(/\n{3,}/, "\n\n")
        A server SHALL support searching by
        #{search_param_name_string} on the #{resource_type} resource. This test
        will pass if resources are returned and match the search criteria. If
        none are returned, the test is skipped.

        [US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/#{url_version}/CapabilityStatement-us-core-server.html)
        DESCRIPTION
      end
    end
  end
end
