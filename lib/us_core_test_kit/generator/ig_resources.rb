module USCoreTestKit
  class Generator
    class IGResources
      def add(resource)
        resources_by_type[resource.resourceType] << resource
      end

      def capability_statement(mode = 'server')
        resources_by_type['CapabilityStatement'].find do |capability_statement_resource|
          capability_statement_resource.rest.any? { |r| r.mode == mode }
        end
      end

      def ig
        resources_by_type['ImplementationGuide'].first
      end

      def inspect
        'IGResources'
      end

      def profile_by_url(url)
        resources_by_type['StructureDefinition'].find { |profile| profile.url == url }
      end

      def resource_for_profile(url)
        resources_by_type['StructureDefinition'].find { |profile| profile.url == url }.type
      end

      def value_set_by_url(url)
        resources_by_type['ValueSet'].find { |profile| profile.url == url }
      end

      def search_param_by_resource_and_name(resource, name)
        normalized_name = name.to_s
        normalized_name = normalized_name.start_with?('_') ? normalized_name[1..] : normalized_name

        resources_by_type['SearchParameter']
          .find { |param| param.id == "us-core-#{resource.downcase}-#{normalized_name}" }
      end

      private

      def resources_by_type
        @resources_by_type ||= Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
