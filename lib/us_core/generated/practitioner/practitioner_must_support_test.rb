require_relative '../../must_support_test'

module USCore
  class PractitionerMustSupportTest < Inferno::Test
    include USCore::MustSupportTest

    title 'All must support elements are provided in the Practitioner resources returned'
    description %(
      US Core Responders SHALL be capable of populating all data elements as
      part of the query results as specified by the US Core Server Capability
      Statement. This test will look through the Practitioner resources
      found previously for the following must support elements:

      * Practitioner.identifier
      * Practitioner.identifier.system
      * Practitioner.identifier.value
      * Practitioner.identifier:NPI
      * Practitioner.name
      * Practitioner.name.family
    )

    id :practitioner_must_support_test

    def resource_type
      'Practitioner'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:practitioner_resources] ||= {}
    end

    run do
      perform_must_support_test(all_scratch_resources)
    end
  end
end
