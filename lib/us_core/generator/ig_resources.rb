module USCore
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

      private

      def resources_by_type
        @resources_by_type ||= Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
