# monkey patch Inferno core to use custom client

puts "USING CUSTOM ASSETS FOLDER"

module Inferno
  module Utils
    # @private
    class StaticAssets
      class << self
        def inferno_path
          # hijack inferno_core/lib/inferno path with monkey_patch path
          @inferno_path = __dir__
        end

        # A hash of urls => file_paths which will be served with `Rack::Static`
        def static_assets_map
          puts "STATIC ASSETS FOLDER: ", @static_assets_folder

          Dir.glob(File.join(static_assets_folder, '*'))
            .each_with_object({}) do |filename, hash|
              hash["#{public_path}/#{File.basename(filename)}"] = filename.delete_prefix(inferno_path)
            end
        end
      end
    end
  end
end
