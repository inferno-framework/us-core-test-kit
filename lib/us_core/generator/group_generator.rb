require_relative 'naming'
require_relative 'special_cases'

module USCore
  class Generator
    class GroupGenerator
      class << self
        def generate(ig_metadata)
          ig_metadata.ordered_groups
            .reject { |group| SpecialCases.exclude_resource? group.resource }
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

      def base_metadata_file_name
        "metadata.yml"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
      end

      def title
        group_metadata.title
      end

      def output_file_name
        File.join(__dir__, '..', 'generated', base_output_file_name)
      end

      def metadata_file_name
        File.join(__dir__, '..', 'generated', profile_identifier, base_metadata_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        "us_core_311_#{profile_identifier}"
      end

      def resource_type
        group_metadata.resource
      end

      def profile_name
        group_metadata.profile_name
      end

      def profile_url
        group_metadata.profile_url
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
        group_metadata.id = group_id
        group_metadata.file_name = base_output_file_name
        File.open(metadata_file_name, 'w') { |f| f.write(YAML.dump(group_metadata.to_hash)) }
      end

      def test_id_list
        @test_id_list ||=
          group_metadata.tests.map { |test| test[:id] }
      end

      def test_file_list
        @test_file_list ||=
          group_metadata.tests.map { |test| test[:file_name].delete_suffix('.rb') }
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

      def search_description
        return '' if required_searches.blank?

        <<~SEARCH_DESCRIPTION
        ## Searching
        This test sequence will first perform each required search associated
        with this resource. This sequence will perform searches with the
        following parameters:

        #{search_param_name_string}

        ### Search Parameters
        The first search uses the selected patient(s) from the prior launch
        sequence. Any subsequent searches will look for its parameter values
        from the results of the first search. For example, the `identifier`
        search in the patient sequence is performed by looking for an existing
        `Patient.identifier` from any of the resources returned in the `_id`
        search. If a value cannot be found this way, the search is skipped.

        ### Search Validation
        Inferno will retrieve up to the first 20 bundle pages of the reply for
        #{resource_type} resources and save them for subsequent tests. Each of
        these resources is then checked to see if it matches the searched
        parameters in accordance with [FHIR search
        guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
        for example, if a Patient search for `gender=male` returns a `female`
        patient.
        SEARCH_DESCRIPTION
      end

      def description
        <<~DESCRIPTION
        # Background

        The US Core #{title} sequence verifies that the system under test is
        able to provide correct responses for #{resource_type} queries. These queries
        must contain resources conforming to the #{profile_name} as
        specified in the US Core v3.1.1 Implementation Guide.

        # Testing Methodology
        #{search_description}

        ## Must Support
        Each profile contains elements marked as "must support". This test
        sequence expects to see each of these elements at least once. If at
        least one cannot be found, the test will fail. The test will look
        through the #{resource_type} resources found in the first test for these
        elements.

        ## Profile Validation
        Each resource returned from the first search is expected to conform to
        the [#{profile_name}](#{profile_url}). Each element is checked against
        teminology binding and cardinality requirements.

        Elements with a required binding are validated against their bound
        ValueSet. If the code/system in the element is not part of the ValueSet,
        then the test will fail.

        ## Reference Validation
        Each reference within the resources found from the previous tests must
        resolve. The test will attempt to read each reference found and will
        fail if any attempted read fails.
        DESCRIPTION
      end
    end
  end
end
