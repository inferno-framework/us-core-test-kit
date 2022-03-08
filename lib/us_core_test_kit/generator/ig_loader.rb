require 'active_support/all'
require 'fhir_models'
require 'rubygems/package'
require 'zlib'
require_relative 'ig_resources'

module USCoreTestKit
  class Generator
    class IGLoader
      attr_accessor :base_ig_directory

      def initialize(base_ig_directory)
        self.base_ig_directory = base_ig_directory
      end

      def ig_resources
        @ig_resources ||= IGResources.new
      end

      def load
        load_ig
        load_standalone_resources
      end

      def load_ig
        tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(File.join(base_ig_directory, 'package.tgz')))

        tar.each do |entry|
          next if entry.directory?

          file_name = entry.full_name.split('/').last

          next unless file_name.end_with? '.json'

          next unless entry.full_name.start_with? 'package/'

          begin
            resource = FHIR.from_contents(entry.read)
            next if resource.nil?
          rescue StandardError
            puts "#{file_name} does not appear to be a FHIR resource."
            next
          end

          ig_resources.add(resource)
        end

        ig_resources
      end

      def load_standalone_resources
        Dir.glob(File.join(base_ig_directory, '*.json')).each do |file_path|
          begin
            resource = FHIR.from_contents(File.read(file_path))
            next if resource.nil?
          rescue StandardError
            file_name = file_path.split('/').last
            puts "#{file_name} does not appear to be a FHIR resource."
            next
          end

          ig_resources.add(resource)
        end

        ig_resources
      end
    end
  end
end
