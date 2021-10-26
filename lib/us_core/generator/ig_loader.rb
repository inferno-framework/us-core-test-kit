require 'active_support/all'
require 'fhir_models'
require 'rubygems/package'
require 'zlib'
require_relative 'ig_resources'

module USCore
  class Generator
    class IGLoader
      def ig_resources
        @ig_resources ||= IGResources.new
      end

      def load
        tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(File.join(__dir__, '..', 'igs', 'package.tgz')))

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
    end
  end
end
