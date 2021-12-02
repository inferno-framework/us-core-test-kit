require_relative '../../must_support_test'

module USCore
  class LocationMustSupportTest < Inferno::Test
    include USCore::MustSupportTest

    title 'All must support elements are provided in the Location resources returned'
    description %(
      US Core Responders SHALL be capable of populating all data elements as
      part of the query results as specified by the US Core Server Capability
      Statement. This test will look through the Location resources
      found previously for the following must support elements:

      * Location.address
      * Location.address.city
      * Location.address.line
      * Location.address.postalCode
      * Location.address.state
      * Location.managingOrganization
      * Location.name
      * Location.status
      * Location.telecom
    )

    id :location_must_support_test

    def resource_type
      'Location'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:location_resources] ||= {}
    end

    run do
      perform_must_support_test(all_scratch_resources)
    end
  end
end
