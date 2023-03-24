require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV600_BALLOT
    class ServiceRequestMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the ServiceRequest resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the ServiceRequest resources
        found previously for the following must support elements:

        * ServiceRequest.authoredOn
        * ServiceRequest.category
        * ServiceRequest.category:us-core
        * ServiceRequest.code
        * ServiceRequest.intent
        * ServiceRequest.occurrencePeriod
        * ServiceRequest.requester
        * ServiceRequest.status
        * ServiceRequest.subject

        For ONC USCDI requirements, each ServiceRequest must support the following additional elements:

        * ServiceRequest.reasonCode or ServiceRequest.reasonReference
      )

      id :us_core_v600_ballot_service_request_must_support_test

      def resource_type
        'ServiceRequest'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
