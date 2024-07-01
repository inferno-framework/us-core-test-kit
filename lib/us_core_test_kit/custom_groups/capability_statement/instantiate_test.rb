module USCoreTestKit
  class InstantiateTest < Inferno::Test
    id :us_core_instantiate
    title 'Server instantiates US Core Server'
    description %(
        This test inspects the CapabilityStatement returned by the server to
        verify that the server instantiates http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server
      )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      include_us_core = capability_statement.instantiates&.any? do |url|
        url.split('|').first == 'http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server'
      end

      assert include_us_core,
             "Server CapabilityStatement.instantiates does not include 'http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server'"
    end
  end
end
