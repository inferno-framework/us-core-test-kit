module USCoreTestKit
  class Generator
    class ResourceListGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          @ig_metadata = ig_metadata

          FileUtils.mkdir_p(base_output_dir)
          File.open(File.join(base_output_dir, base_output_file_name), 'w') { |f| f.write(output) }
        end

        def resource_list
          @ig_metadata.groups.map(&:resource).uniq
        end

        def resource_list_string
          resource_list.map { |resource| "      '#{resource}'" }.join(",\n")
        end

        def module_name
          "USCore#{@ig_metadata.reformatted_version.upcase}"
        end

        def read_interaction(group_metadata)
          group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
        end

        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'resource_list.rb.erb'))
        end

        def output
          @output ||= ERB.new(template).result(binding)
        end

        def base_output_file_name
          "resource_list.rb"
        end
      end
    end
  end
end
