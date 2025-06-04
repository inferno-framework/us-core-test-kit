require 'fhir_models'
require 'inferno/ext/fhir_models'

require_relative '../generator/ig_loader'
require_relative '../generator/ig_metadata_extractor'

require_relative 'generator/group_generator'
require_relative 'generator/tags_generator'
require_relative 'generator/urls_generator'
require_relative 'generator/suite_generator'
require_relative 'generator/read_test_generator'
require_relative 'generator/search_test_generator'
require_relative 'generator/wait_group_generator'
require_relative 'generator/read_endpoint_generator'
require_relative 'generator/search_endpoint_generator'
require_relative 'generator/auth_smart_group_generator'
require_relative 'generator/registration_group_generator'
require_relative 'generator/registration_configuration_display_test_generator'

module USCoreTestKit
  module Client
    class Generator
      def self.generate
        ig_packages = Dir.glob(File.join(Dir.pwd, 'lib', 'us_core_test_kit', 'igs', '*.tgz'))

        ig_packages.each do |ig_package|
          new(ig_package).generate
        end
      end

      attr_accessor :ig_resources, :ig_metadata, :ig_file_name

      def initialize(ig_file_name)
        self.ig_file_name = ig_file_name
      end

      def generate
        puts "Generating client suites for IG #{File.basename(ig_file_name)}"

        load_ig_package
        extract_metadata

        generate_tags
        generate_urls
        generate_read_tests
        generate_search_tests
        generate_wait_group
        generate_endpoints
        generate_registration_tests
        generate_auth_tests

        generate_groups
        generate_suites
      end

      def extract_metadata
        self.ig_metadata = USCoreTestKit::Generator::IGMetadataExtractor.new(ig_resources).extract

        FileUtils.mkdir_p(base_output_dir)
      end

      def base_output_dir
        File.join(__dir__, 'generated', ig_metadata.ig_version)
      end

      def load_ig_package
        FHIR.logger = Logger.new('/dev/null')
        self.ig_resources = USCoreTestKit::Generator::IGLoader.new(ig_file_name).load
      end

      def generate_groups
        GroupGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_tags
        TagsGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_urls
        UrlsGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_suites
        SuiteGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_wait_group
        WaitGroupGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_read_tests
        ReadTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_search_tests
        SearchTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_endpoints
        ReadEndpointGenerator.generate(ig_metadata, base_output_dir)
        SearchEndpointGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_registration_tests
        RegistrationGroupGenerator.generate(ig_metadata, base_output_dir)
        FileUtils.mkdir_p(File.join(base_output_dir, 'registration'))
        RegistrationConfigurationDisplayTestGenerator.generate(ig_metadata, base_output_dir, 'smart')
      end

      def generate_auth_tests
        AuthSMARTGroupGenerator.generate(ig_metadata, base_output_dir, 'alca')
        AuthSMARTGroupGenerator.generate(ig_metadata, base_output_dir, 'alcs')
        AuthSMARTGroupGenerator.generate(ig_metadata, base_output_dir, 'alp')
      end
    end
  end
end
