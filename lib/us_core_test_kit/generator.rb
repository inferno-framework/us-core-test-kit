require 'fhir_models'

require_relative 'ext/fhir_models'
require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'
require_relative 'generator/group_generator'
require_relative 'generator/must_support_test_generator'
require_relative 'generator/provenance_revinclude_search_test_generator'
require_relative 'generator/read_test_generator'
require_relative 'generator/reference_resolution_test_generator'
require_relative 'generator/resource_list_generator'
require_relative 'generator/search_test_generator'
require_relative 'generator/suite_generator'
require_relative 'generator/validation_test_generator'

module USCoreTestKit
  class Generator
    def self.generate
      base_ig_directory = File.join(Dir.pwd, 'lib', 'us_core_test_kit', 'igs')
      ig_directories =
        Dir.entries(base_ig_directory)
          .reject { |path| path.start_with? '.' }
          .map { |path| File.join(base_ig_directory, path) }
          .select { |path| File.directory? path }

      ig_directories.each do |ig_directory|
        new(ig_directory).generate
      end
    end

    attr_accessor :ig_resources, :ig_metadata, :ig_directory

    def initialize(ig_directory)
      self.ig_directory = ig_directory
    end

    def generate
      puts "Generating tests for IG in #{ig_directory}"
      load_ig_package
      extract_metadata
      generate_resource_list
      generate_search_tests
      generate_read_tests
      # TODO: generate_vread_tests
      # TODO: generate_history_tests
      generate_provenance_revinclude_search_tests
      generate_validation_tests
      generate_must_support_tests
      generate_reference_resolution_tests

      generate_groups

      generate_suites
    end

    def extract_metadata
      self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract

      FileUtils.mkdir_p(base_output_dir)
      File.open(File.join(base_output_dir, 'metadata.yml'), 'w') do |file|
        file.write(YAML.dump(ig_metadata.to_hash))
      end
    end

    def base_output_dir
      File.join(__dir__, 'generated', ig_metadata.ig_version)
    end

    def load_ig_package
      FHIR.logger = Logger.new('/dev/null')
      self.ig_resources = IGLoader.new(ig_directory).load
    end

    def generate_resource_list
      ResourceListGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_reference_resolution_tests
      ReferenceResolutionTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_must_support_tests
      MustSupportTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_validation_tests
      ValidationTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_read_tests
      ReadTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_search_tests
      SearchTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_provenance_revinclude_search_tests
      ProvenanceRevincludeSearchTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_groups
      GroupGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_suites
      SuiteGenerator.generate(ig_metadata, base_output_dir)
    end
  end
end
