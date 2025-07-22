require 'fhir_models'
require 'inferno/ext/fhir_models'

require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'
require_relative 'generator/granular_scope_group_generator'
require_relative 'generator/granular_scope_resource_type_group_generator'
require_relative 'generator/granular_scope_test_generator'
require_relative 'generator/granular_scope_read_test_generator'
require_relative 'generator/group_generator'
require_relative 'generator/must_support_test_generator'
require_relative 'generator/provenance_revinclude_search_test_generator'
require_relative 'generator/read_test_generator'
require_relative 'generator/reference_resolution_test_generator'
require_relative 'generator/search_test_generator'
require_relative 'generator/suite_generator'
require_relative 'generator/validation_test_generator'
require_relative 'generator/practitioner_address_test_generator'
require_relative 'generator/interpreter_required_extension_test_generator'
require_relative 'generator/verifies_requirements'

module USCoreTestKit
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
      puts "Generating tests for IG #{File.basename(ig_file_name)}"
      load_ig_package
      extract_metadata
      generate_search_tests
      generate_read_tests
      # TODO: generate_vread_tests
      # TODO: generate_history_tests
      generate_provenance_revinclude_search_tests
      generate_validation_tests
      generate_must_support_tests
      generate_reference_resolution_tests
      generate_practitioner_address_tests
      generate_interpreter_required_extension_test_generator

      generate_granular_scope_tests

      generate_groups

      generate_granular_scope_resource_type_groups

      generate_granular_scope_groups

      generate_suites

      write_metadata
    end

    def extract_metadata
      self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract

      FileUtils.mkdir_p(base_output_dir)
    end

    def write_metadata
      File.write(File.join(base_output_dir, 'metadata.yml'), YAML.dump(ig_metadata.to_hash))
    end

    def base_output_dir
      File.join(__dir__, 'generated', ig_metadata.ig_version)
    end

    def load_ig_package
      FHIR.logger = Logger.new('/dev/null')
      self.ig_resources = IGLoader.new(ig_file_name).load
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

    def generate_granular_scope_tests
      GranularScopeTestGenerator.generate(ig_metadata, base_output_dir)
      GranularScopeReadTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_groups
      GroupGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_granular_scope_resource_type_groups
      GranularScopeResourceTypeGroupGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_granular_scope_groups
      GranularScopeGroupGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_practitioner_address_tests
      PractitionerAddressTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_interpreter_required_extension_test_generator
      InterpreterRequiredExtensionTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_suites
      SuiteGenerator.generate(ig_metadata, base_output_dir)
    end
  end
end
