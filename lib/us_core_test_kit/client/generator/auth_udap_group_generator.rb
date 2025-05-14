# frozen_string_literal: true

module USCoreTestKit
  module Client
    class Generator
      class AuthUDAPGroupGenerator
        class << self
          def generate(ig_metadata, base_output_dir)
            new(ig_metadata, base_output_dir).generate
          end
        end

        attr_accessor :ig_metadata, :base_output_dir

        def initialize(ig_metadata, base_output_dir)
          self.ig_metadata = ig_metadata
          self.base_output_dir = base_output_dir
        end

        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'auth_udap_group.rb.erb'))
        end

        def output
          @output ||= ERB.new(template, trim_mode: '-').result(binding)
        end

        def version
          ig_metadata.reformatted_version.downcase
        end

        def base_output_file_name
          "auth_udap_group.rb"
        end

        def module_name
          "USCoreClient#{ig_metadata.reformatted_version.upcase}"
        end

        def output_file_name
          File.join(base_output_dir, base_output_file_name)
        end

        def generate
          File.write(output_file_name, output)
        end
      end
    end
  end
end
