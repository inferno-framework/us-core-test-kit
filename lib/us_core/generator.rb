require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'

module USCore
  class Generator
    attr_accessor :ig_resources, :ig_metadata

    def load_ig_package
      FHIR.logger = Logger.new('/dev/null')
      self.ig_resources = IGLoader.new.load
      self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract
    end

    def inspect
      'Generator'
    end
  end
end
