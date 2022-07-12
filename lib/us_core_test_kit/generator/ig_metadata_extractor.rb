require_relative 'ig_metadata'
require_relative 'group_metadata_extractor'

module USCoreTestKit
  class Generator
    class IGMetadataExtractor
      attr_accessor :ig_resources, :metadata

      def initialize(ig_resources)
        self.ig_resources = ig_resources
        add_missing_supported_profiles
        self.metadata = IGMetadata.new
      end

      def extract
        add_metadata_from_ig
        add_metadata_from_resources
        metadata
      end

      def add_metadata_from_ig
        metadata.ig_version = "v#{ig_resources.ig.version}"
      end

      def resources_in_capability_statement
        ig_resources.capability_statement.rest.first.resource
      end

      # The US Core Server Capability Statement does not list support for the
      # required vital signs profiles, so they need to be added
      def add_missing_supported_profiles
        case ig_resources.ig.version
        when '3.1.1'
          ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Observation' }
            .supportedProfile.concat [
              'http://hl7.org/fhir/StructureDefinition/bodyheight',
              'http://hl7.org/fhir/StructureDefinition/bodytemp',
              'http://hl7.org/fhir/StructureDefinition/bp',
              'http://hl7.org/fhir/StructureDefinition/bodyweight',
              'http://hl7.org/fhir/StructureDefinition/heartrate',
              'http://hl7.org/fhir/StructureDefinition/resprate'
            ]
        when '5.0.1'
          ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Encounter' }
            .supportedProfile.concat [
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter'
            ]
        end
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_capability_statement.flat_map do |resource|
            resource.supportedProfile&.map do |supported_profile|
              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end

        metadata.postprocess_groups(ig_resources)
      end
    end
  end
end
