require_relative '../../must_support_test'

module USCoreTestKit
  class SmokingstatusMustSupportTest < Inferno::Test
    include USCoreTestKit::MustSupportTest

    title 'All must support elements are provided in the Observation resources returned'
    description %(
      US Core Responders SHALL be capable of populating all data elements as
      part of the query results as specified by the US Core Server Capability
      Statement. This test will look through the Observation resources
      found previously for the following must support elements:

      * Observation.code
      * Observation.issued
      * Observation.status
      * Observation.subject
      * Observation.value[x]:valueCodeableConcept
    )

    id :us_core_311_smokingstatus_must_support_test

    def resource_type
      'Observation'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:smokingstatus_resources] ||= {}
    end

    run do
      perform_must_support_test(all_scratch_resources)
    end
  end
end
