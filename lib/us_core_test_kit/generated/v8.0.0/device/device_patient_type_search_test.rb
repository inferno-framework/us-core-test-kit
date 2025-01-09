require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class DevicePatientTypeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Device search by patient + type'
      description %(
A server SHOULD support searching by
patient + type on the Device resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/2025Jan/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_device_patient_type_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      input :implantable_device_codes,
        title: 'Implantable Device Type Code',
        description: 'Enter the code for an Implantable Device type, or multiple codes separated by commas. '\
                    'If blank, Inferno will validate all Device resources against the Implantable Device profile',
        optional: true
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Device',
        search_param_names: ['patient', 'type'],
        possible_status_search: true,
        token_search_params: ['type']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
