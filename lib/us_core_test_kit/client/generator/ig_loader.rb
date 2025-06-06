require_relative '../generator/ig_loader'
require_relative 'ig_resources'

module USCoreTestKit
  module Client
    class Generator
      class IGLoader < USCoreTestKit::Generator::IGLoader
        def ig_resources
          @ig_resources ||= IGResources.new
        end
      end
    end
  end
end
