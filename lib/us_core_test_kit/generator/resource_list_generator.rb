module USCoreTestKit
  class Generator
    class ResourceListGenerator
      class << self
        def generate(ig_metadata)
          @ig_metadata = ig_metadata

          FileUtils.mkdir_p(output_file_directory)
          File.open(output_file_name, 'w') { |f| f.write(output) }
        end

        def resource_list
          @ig_metadata.groups.map(&:resource).uniq
        end

        def resource_list_string
          resource_list.map { |resource| "      '#{resource}'" }.join(",\n")
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

        def output_file_directory
          File.join(__dir__, '..', 'generated')
        end

        def output_file_name
          File.join(output_file_directory, base_output_file_name)
        end
      end
    end
  end
end
