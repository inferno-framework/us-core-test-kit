require 'fileutils'
require 'json'
require 'rubygems/package'
require 'zlib'

module USCoreTestKit
  # .tgz file processing based on
  # https://gist.github.com/sinisterchipmunk/1335041/5be4e6039d899c9b8cca41869dc6861c8eb71f13
  class IGProcessor
    def self.process
      raw_ig_path = File.join(__dir__, 'raw_igs')
      processed_ig_path = File.join(__dir__, 'igs')
      new(raw_ig_path, processed_ig_path).process
    end

    attr_accessor :raw_ig_path, :processed_ig_path

    def initialize(raw_ig_path, processed_ig_path)
      self.raw_ig_path = raw_ig_path
      self.processed_ig_path = processed_ig_path
    end

    def processed_igs
      @processed_igs ||= []
    end

    def process
      extract_igs
      remove_older_dependencies('us.nlm.vsac')
      replace_original_igs
    end

    def extract_igs
      Dir.glob(File.join(raw_ig_path, '*.tgz')).each do |ig_file_name|
        tar = Gem::Package::TarReader.new(
          Zlib::GzipReader.open(ig_file_name)
        )

        tar_file_name = File.basename(ig_file_name, '.tgz')
        processed_igs << tar_file_name

        tar.each do |entry|
          destination_file_name = File.join(raw_ig_path, tar_file_name, entry.full_name)

          if entry.directory?
            FileUtils.mkdir_p destination_file_name
          else
            destination_directory = File.dirname(destination_file_name)
            FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
            File.open(destination_file_name, 'wb') { |f| f.write entry.read }
          end
        end
      end
    end

    def remove_older_dependencies(package_name)
      max_version = max_package_version(package_name)

      package_json_paths.each do |package_json_path|
        package_json = JSON.parse(File.read(package_json_path))
        dependencies = package_json['dependencies']

        next if dependencies[package_name].nil? || dependencies[package_name] == max_version

        dependencies.delete package_name
        File.open(package_json_path, 'w') { |f| f.write JSON.pretty_generate(package_json) }
      end
    end

    def replace_original_igs
      processed_igs
        .each_with_object({}) do |ig_file_name, hash|
          input_ig_path = File.join(raw_ig_path, ig_file_name)
          hash[ig_file_name] = gzip(tar(input_ig_path))
        end
        .each do |ig_file_name, contents|
          output_ig_path = File.join(processed_ig_path, "#{ig_file_name}.tgz")
          File.open(output_ig_path, 'wb') { |f| f.write(contents.read) }
        end
    end

    def tar(path)
      tarfile = StringIO.new("")
      Gem::Package::TarWriter.new(tarfile) do |tar|
        Dir[File.join(path, "**/*")].each do |file|
          mode = File.stat(file).mode
          relative_file = file.sub /^#{Regexp::escape path}\/?/, ''

          if File.directory?(file)
            tar.mkdir relative_file, mode
          else
            tar.add_file relative_file, mode do |tf|
              File.open(file, "rb") { |f| tf.write f.read }
            end
          end
        end
      end

      tarfile
    end

    def gzip(tarfile)
      gz = StringIO.new("")
      z = Zlib::GzipWriter.new(gz)
      z.write tarfile.string
      z.close # this is necessary!

      # z was closed to write the gzip footer, so
      # now we need a new StringIO
      StringIO.new gz.string
    end

    def package_json_paths
      processed_igs.map do |ig_file_name|
        File.join(raw_ig_path, ig_file_name, 'package','package.json')
      end
    end

    def package_versions(package_name)
      package_json_paths.map do |package_json_path|
        package_json = JSON.parse(File.read(package_json_path))
        package_json.dig('dependencies', package_name)
      end.compact
    end

    def max_package_version(package_name)
        package_versions(package_name)
          .sort { |v1, v2| compare_versions(v1, v2) }
          .last
    end

    def compare_versions(v1, v2)
      v1_major, v1_minor, v1_patch = v1.split('.')
      v2_major, v2_minor, v2_patch = v2.split('.')

      if v1_major.to_i < v2_major.to_i
        return -1
      elsif v2_major.to_i < v1_major.to_i
        return 1
      end

      if v1_minor.to_i < v2_minor.to_i
        return -1
      elsif v2_minor.to_i < v1_minor.to_i
        return 1
      end

      if v1_patch.to_i < v2_patch.to_i
        return -1
      elsif v2_patch.to_i < v1_patch.to_i
        return 1
      end

      return 0
    end
  end
end
