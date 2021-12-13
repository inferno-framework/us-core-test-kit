require_relative 'capability_statement/conformance_support_test'
require_relative 'capability_statement/fhir_version_test'
require_relative 'capability_statement/json_support_test'
require_relative 'capability_statement/profile_support_test'

module USCore
  class CapabilityStatementGroup < Inferno::TestGroup
    id :us_core_311_capability_statement
    title 'Capability Statement'
    description %(
      # Background
      The #{title} Sequence tests a FHIR server's ability to formally describe
      features supported by the API by using the [Capability
      Statement](https://www.hl7.org/fhir/capabilitystatement.html) resource.
      The features described in the Capability Statement must be consistent with
      the required capabilities of a US Core server. The Capability Statement
      must also advertise the location of the required SMART on FHIR endpoints
      that enable authenticated access to the FHIR server resources.

      The Capability Statement resource allows clients to determine which
      resources are supported by a FHIR Server. Not all servers are expected to
      implement all possible queries and data elements described in the US Core
      API. For example, the US Core Implementation Guide requires that the
      Patient resource and only one additional resource profile from the US Core
      Profiles.

      # Test Methodology

      This test sequence accesses the server endpoint at `/metadata` using a
      `GET` request. It parses the Capability Statement and verifies that:

      * The endpoint is secured by an appropriate cryptographic protocol
      * The resource matches the expected FHIR version defined by the tests
      * The resource is a valid FHIR resource
      * The server claims support for JSON encoding of resources
      * The server claims support for the Patient resource and one other
        resource

      It collects the following information that is saved in the testing session
      for use by later tests:

      * List of resources supported
      * List of queries parameters supported
    )
    run_as_group

    test from: :us_core_311_conformance_support
    test from: :us_core_311_fhir_version
    test from: :us_core_311_json_support
    test from: :us_core_311_profile_support
  end
end
