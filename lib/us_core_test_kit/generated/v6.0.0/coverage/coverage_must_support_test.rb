require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV600
    class CoverageMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Coverage resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Coverage resources
        found previously for the following must support elements:

        * Coverage.beneficiary
        * Coverage.class
        * Coverage.class.name
        * Coverage.class.value
        * Coverage.class:group
        * Coverage.class:plan
        * Coverage.identifier
        * Coverage.identifier.type.coding.code
        * Coverage.identifier:memberid
        * Coverage.payor
        * Coverage.period
        * Coverage.relationship
        * Coverage.status
        * Coverage.subscriberId
        * Coverage.type
      )

      id :us_core_v600_coverage_must_support_test

      def resource_type
        'Coverage'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:coverage_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
