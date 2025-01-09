require_relative 'version'

module USCoreTestKit
  class Metadata < Inferno::TestKit
    id :us_core_test_kit
    title 'US Core Test Kit'
    description <<~DESCRIPTION
      The US Core Test Kit validates the conformance of a server implementation to a specific
      version of the [US Core IG](http://hl7.org/fhir/us/core). Currently, Inferno can test
      against implementations of following versions of the US Core IG:
      [v3.1.1](http://hl7.org/fhir/us/core/STU3.1.1/),
      [v4.0.0](http://hl7.org/fhir/us/core/STU4/),
      [v5.0.1](http://hl7.org/fhir/us/core/STU5.0.1/),
      [v6.1.0](https://hl7.org/fhir/us/core/STU6.1/),
      and
      [v7.0.0](https://hl7.org/fhir/us/core/STU7/).
      <!-- break -->

      TODO grab full us core description 
    DESCRIPTION
    suite_ids [:us_core_v311, :us_core_v400, :us_core_v501, :us_core_v610, :us_core_v700]
    tags ['SMART App Launch', 'US Core']
    last_updated '2024-12-05'
    version VERSION
    maturity 'Low'
    authors 'inferno-gang@mitre.org'
    repo 'https://github.com/inferno-framework/us-core-test-kit'
  end
end
