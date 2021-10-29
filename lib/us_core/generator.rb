require 'fhir_models'

require_relative 'ext/fhir_models'
require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'
require_relative 'generator/group_generator'
require_relative 'generator/read_test_generator'

module USCore
  class Generator
    attr_accessor :ig_resources, :ig_metadata

    def generate
      load_ig_package
      extract_metadata
      generate_read_tests
      generate_groups
    end

    def extract_metadata
      self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract
      File.open('metadata.yml', 'w') do |file|
        file.write(YAML.dump(ig_metadata.to_hash))
      end
    end

    def load_ig_package
      FHIR.logger = Logger.new('/dev/null')
      self.ig_resources = IGLoader.new.load
    end

    def generate_read_tests
      ReadTestGenerator.generate(ig_metadata)
    end

    def generate_groups
      GroupGenerator.generate(ig_metadata)
    end
  end
end
