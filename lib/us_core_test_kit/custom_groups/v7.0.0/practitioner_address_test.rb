require_relative '../../practitioner_address_test'

module USCoreTestKit
  module USCoreV700
    class PractitionerAddressTest < Inferno::Test
      include USCoreTestKit::PractitionerAddressTest

      id :us_core_v700_practitioner_address_test
      title 'Server support either Practitioner.address or PractitionerRole'

      description %(
        US Core Responders SHALL support either US Core PractitionerRole Profile or
        these data elements in US Core Practitioner Profile

        * Practitioner.address
        * Practitioner.address.city
        * Practitioner.address.country
        * Practitioner.address.line
        * Practitioner.address.postalCode
        * Practitioner.address.state
      )

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '../../generated/v7.0.0/practitioner/metadata.yml'), aliases: true))
      end

      run do
        verify_practitioner_address
      end
    end
  end
end
