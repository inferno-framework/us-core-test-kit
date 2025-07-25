require_relative 'version'

module USCoreTestKit
  class Metadata < Inferno::TestKit
    id :us_core_test_kit
    title 'US Core Test Kit'
    description <<~DESCRIPTION
      The US Core Test Kit validates the conformance of server and client implementations to a specific
      version of the [US Core IG](http://hl7.org/fhir/us/core). Currently, Inferno can test
      against implementations of following versions of the US Core IG:
      [v3.1.1](http://hl7.org/fhir/us/core/STU3.1.1/),
      [v4.0.0](http://hl7.org/fhir/us/core/STU4/),
      [v5.0.1](http://hl7.org/fhir/us/core/STU5.0.1/),
      [v6.1.0](https://hl7.org/fhir/us/core/STU6.1/),
      [v7.0.0](https://hl7.org/fhir/us/core/STU7/),
      and
      [v8.0.0](https://hl7.org/fhir/us/core/STU8/).
      <!-- break -->

      This test kit is [open source](https://github.com/inferno-framework/us-core-test-kit#license)
      and freely available for use or adoption by the health IT community including EHR vendors,
      health app developers, and testing labs. It is built using the
      [Inferno Framework](https://inferno-framework.github.io/inferno-core/).
      The Inferno Framework is designed for reuse and aims to make it easier to build test kits
      for any FHIR-based data exchange.

      ## Status

      The US Core Test Kit is actively developed and regularly updated. Starting with STU3,
      each STU sequence is kept up-to-date with the latest version. See the test descriptions
      within the test kit for detail on the specific validations performed as part of testing
      these requirements.

      ### Server Suites

      The US Core Server suites are mature tests and currently verify the following requirements:

      - Support for Capability Statement
      - Support for all US Core Profiles
      - Searches required for each resource
      - Support for Must Support Elements
      - Profile Validation
      - Reference Validation
      - Clinical Notes Guidance
      - Missing Data Guidance

      ### Client suites

      The US Core Client suites are less mature and currently verify the following requirements:

      - Support for making requests for data on all US Core Profiles
      - Support for read and search interaction requests
      - Initiate searches using each required search parameter combination

      ## Repository

      The US Core Test Kit GitHub repository can be [found here](https://github.com/inferno-framework/us-core-test-kit).

      ## Providing Feedback and Reporting Issues

      We welcome feedback on the tests, including but not limited to the following areas:

       - Validation logic, such as potential bugs, lax checks, and unexpected failures.
       - Requirements coverage, such as requirements that have been missed, tests that necessitate
         features that the IG does not require, or other issues with the interpretation of the IG’s requirements.
       - User experience, such as confusing or missing information in the test UI.

      Please report any issues with this set of tests in the
      [issues section](https://github.com/inferno-framework/us-core-test-kit/issues)
      of the repository.
    DESCRIPTION
    suite_ids [:us_core_v311, :us_core_v400, :us_core_v501, :us_core_v610, :us_core_v700, :us_core_v800, :us_core_client_v311,
               :us_core_client_v400, :us_core_client_v501, :us_core_client_v610, :us_core_client_v700, :us_core_client_v800]
    tags ['SMART App Launch', 'US Core']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'High'
    authors ['Stephen MacVicar', 'Yunwei Wang']
    repo 'https://github.com/inferno-framework/us-core-test-kit'
  end
end
