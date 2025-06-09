# frozen_string_literal: true

module USCoreTestKit
  module Client
    class Generator
      class WaitGroupGenerator
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
          @template ||= File.read(File.join(__dir__, 'templates', 'wait_group.rb.erb'))
        end

        def output
          @output ||= ERB.new(template).result(binding)
        end

        def class_name
          "WaitGroup"
        end

        def base_output_file_name
          "#{class_name.underscore}.rb"
        end

        def output_file_name
          File.join(base_output_dir, base_output_file_name)
        end

        def groups
          ig_metadata.ordered_groups
            .reject { |group| USCoreTestKit::Generator::SpecialCases.exclude_group? group }
        end

        def check_list
          groups
            .map do |group|
              profile_name = USCoreTestKit::Generator::Naming.upper_camel_case_for_profile(group)
              profile_header = "* **#{profile_name}**"
              profile_id = "  * read id:\n    * us-core-client-tests-#{profile_name.underscore.dasherize}"
              required_searches = group.searches.each do |search|
                next unless search[:expectation] == 'SHALL'

                search
              end
              searches = "  * searches:"
              search_list = required_searches.map do |search|
                "    * #{search[:names].join(' + ')}"
              end
              "#{profile_header}\n#{profile_id}\n#{searches}\n#{search_list.join("\n")}"
            end
            .join("\n")
        end

        def generate
          File.write(output_file_name, output)
        end
      end
    end
  end
end
