# frozen_string_literal: true

module USCoreTestKit
  module Client
    class Generator
      class RegistrationConfigurationDisplayTestGenerator
        class << self
          def generate(ig_metadata, base_output_dir, protocol)
            new(ig_metadata, base_output_dir, protocol).generate
          end
        end

        attr_accessor :ig_metadata, :base_output_dir, :protocol

        def initialize(ig_metadata, base_output_dir, protocol)
          self.ig_metadata = ig_metadata
          self.base_output_dir = base_output_dir
          self.protocol = protocol
        end

        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'registration_configuration_display_test.rb.erb'))
        end

        def output
          @output ||= ERB.new(template, trim_mode: '-').result(binding)
        end

        def version
          ig_metadata.reformatted_version.downcase
        end

        def base_output_file_name
          "configuration_display_#{protocol.downcase}_test.rb"
        end

        def module_name
          "USCoreClient#{ig_metadata.reformatted_version.upcase}"
        end

        def output_file_name
          File.join(base_output_dir, 'registration', base_output_file_name)
        end

        def generate
          File.write(output_file_name, output)
        end
      end
    end
  end
end
