module USCoreTestKit
  module Client
    class Generator
      class IGResources < USCoreTestKit::Generator::IGResources
        def capability_statement(mode = 'client')
          resources_by_type['CapabilityStatement'].find do |capability_statement_resource|
            capability_statement_resource.rest.any? { |r| r.mode == mode }
          end
        end
      end
    end
  end
end
