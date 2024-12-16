# Background

This guide orients developers to the technical design of this Test Kit.  While
the Inferno Framework has documentation on how to create tests, additional
documentation on the organization of this test kit is necessary due to the
complexity involved in developing tests for the US Core guide.

Prior to reviewing this document, the developer is expected to be familiar
with the US Core Test Kit and building tests with the Inferno Framework.

# Test Design Principals and Features

Tests for this Test Kit have been designed with the following principles:

* Easy testing: Users should be able to run the tests with minimal input or
  configuration, and tests should complete in a reasonable amount of time.
* Limit extraneous constraints: The tests should not place additional
  constraints on the system under test.  Leverage machine-readable content: As
  of US Core v7, the US Core developers purposefully encode many requirements in
  machine-readable structures, and hte tests should leverage those when possible
  to avoid mistakes.  Obey all non-machine-readable requirements and exception:
* The tests should not ignore any requirements that are not encoded in
  machine-readable structures.

Features of this test kit reflect these principals.  For example:
* Systems do not need to load a specific set of data for these tests, as long as
  the data they provide are valid and demonstrate complete support for the US
  Core Test Kit.
* Testers supply a very limited amount of information to the
  tests; the tests themselves learn about data provided by the system to
  and automatically generate inputs for subsequent tests.
* This Test Kit generates tests from machine-readable content each time US Core
  is updated.  Additionally, the tests use the HL7 FHIR Validator to do runtime
  validation of resources against profiles provided within US Core.
* Occasionally, the US Core Test Kit overrides machine-readable rules in narrative;
  for example by stating that a 'Must Support' flag may only conditionally apply
  in certain cases.  Special cases are added throughout the tests to allow
  certain exceptions to the machine-readable rules.

The US Core Test Kit manages this complexity through standard software design
practices and approaches, leveraging the functionality provided by the Ruby
programming language.  And while this code is intended to be accessible to
developers new to the Ruby language, developers are expected to learn the basics
of Ruby development before attempting to alter these tests.  This Test Kit also
uses RSpec to "unit test" components of these tests, and developers are expected
to learn the basics of RSpec as well.

# US Core Test Kit Project Source Code Structure:

Below is a description of the source code structure for the US Core Test Kit:

```
root
+--config
| +--presets                   Preset configurations including: server URL, patient IDs, client credentials, etc*
| +--lib                         Functional modules for common testing functionality, such as read test, search test, validation test
| +--us_core_test_kit
| | +--custom_groups           Manually created Tests and Groups, such as Clinical Notes tests, or Data Absent Reason tests
| | | +--capability_statement  Tests for CapabilityStatement
| | | +--v3.1.1
| | | +--v4.0.0
| | | +-- ...
| | +--generated               Tests generated automatically by generator
| | | +--v3.1.1
| | | +--v4.0.0
| | | +-- ...
| | +--generator               Codes for test generator
| | | +--template              Templates used by generators
| | +--igs                     Folder for US Core IGs
| | | +--v3.1.1                Additional SearchParameters, ValueSets, CodeSystems for US Core v3.1.1
| | | +--v5.0.1                Additional SearchParameters, ValueSets, CodeSystems for US Core v5.0.1
| | | +--  ...
+--spec                        Unit tests
```

Importantly, code within the `generated` folder is generated using the
generation script and should *not* be manually edited.  Instead, changes to the
generator should be made in the `generator` folder.

# Related Systems and Dependencies

## Reference Server

The Inferno Reference Server serves as a reference implementation server,
supporting the US Core Implementation Guide, SMART App Launch, and Bulk Data
Export. You can find the project on GitHub at
<https://github.com/inferno-framework/inferno-reference-server>. The Inferno
Reference Server is developed based on the HAPI FHIR Server
(https://github.com/hapifhir/hapi-fhir).

During the upgrade process, it may be necessary to update the data in the
Inferno Reference Server to ensure it conforms to the latest Implementation
Guide. For detailed instructions on how to load data into the server database,
please refer to the README.md file on the GitHub repository.

## SMART App Launch Test Kit

The Inferno US Core Test Kit incorporates an optional test group from the SMART
App Launch Test Kit. The purpose of the SMART App Launch Test Kit is to confirm
a server's ability to provide authorization and/or authentication services to
client applications that access HL7® FHIR® APIs. You can find this test kit on
GitHub at <https://github.com/inferno-framework/smart-app-launch-test-kit>.

This test kit also contains tests for specific guidance provided by US Core
regarding the implementation of SMART App Launch.  This is typically provided
in response to any potential ambiguity that results from the combination of
FHIR, US Core and SMART App Launch, particularly when relevant to certification
activities in the US.

# Testing Code Changes

This test kit includes comprehensive "self testing" functionality to provide
confidence that the tests perform as expected.  It also contains a set of data
that can be loaded into a FHIR server, such as the Inferno Reference Server,
to demonstrate the functionality of the tests against a known correct implementation.
Both of these should be maintained along with the tests.

Prior to altering tests, developers should ensure that both RSpec tests and
End-to-End tests pass.

## RSpec Tests

The test kit contains many "unit" tests within the `spec` directory.  These
tests are written in RSpec, and can be run with the following command:

```bundle exec rake spec```

These tests should be run after any changes to the tests, and must pass before
any changes to the tests are merged into the main branch.  It is not expected
that the code base achieves 100% test coverage; instead, the team has followed a
common sense approach to testing components that 1) are complicated or 2) are
likely to change.

## End-to-End testing

Besides the unit tests provided within this Test Kit, after each update
the tests should be validated against a complete server implementation
that is known to be correct.  The Inferno Reference Server provides this functionality,
and contains data that passes all of these tests.  Note that if test changes
have been made that require data on the Reference Server to change as well,
that data set needs to be updated.

# Updating the Test Kit

**To update this test kit in response to a new version of the US Core Implementation
Guide, please see the [Version Update Guide](Version-Update-Guide).  The Version
Update Guide provides a detailed walkthrough of the components of the Test Kit
that are changed during this process.**

While developers of this Test Kit should aim to have completely correct tests,
issues will likely be identified by the community over time.  Because this Test Kit
exports tests to the ONC Certification (g)(10) Test Kit, incorrect tests may delay
certification activities for implementers, or even worse, encourage improper
implementations just to make incorrect tests pass.  Therefore, 
the tests should be updated to include the test fixes as soon as possible.

## Updating Generating Tests

The main testing logic for these tests are generated from machine-readable data
provided by each version of the US Core Implementation Guide.  The code for
the generator is within the `lib/us_core_test_kit/generator` directory and
the test suites that are generated are placed within the `lib/us_core_test_kit/generated`
directory.

Never update files in teh `generated` directory manually, as they will be
overwritten when the next time the files are regenerated.

To regenerate the files, run:

```bundle exec rake us\_core:generate```

Each version of the implementation guide provided in the
`lib/us_core_test_kit/igs` directory will be created.

## Updating shared component tests

While the generator creates code for each suite, the generated code typically
references shared component tests. These component tests reside in the
`lib/us_core_test_kit/` directory.  These tests are not generated, and should be
updated manually.  Because they are reused across many test groups, updating
them must be done with care.

Tests that are version specific reside in the
`lib/us_core_test_kit/custom_groups` directory.


## Overriding US Core Content

Occasionally, the US Core authors publish incorrect content within the
implementation guide that affects the generation of tests, or validation of
systems at runtime.  In these cases, the Inferno team will override the content
with the correct content.  This is done by placing the correct content in the
`lib/us_core_test_kit/igs/[version]/` directories.  The content in this
directory will be used instead of the content in the implementation guide.

## Overriding HL7 Validator Behavior

The HL7 Validator is used to validate resources at runtime.  Occasionally, the
HL7 Validator will report validation errors that are considered to be out of
scope of testing, or are incorrect.  In these cases, test can choose to filter
out these error messages.

If the invalid error message applies to all versions of US Core, you can
update the `lib/us_core_test_kit/generator/templates/suite.rb.erb` file.  If it
only applies to a certain version of US Core, you can update the
`lib/us_core_test_kit/generator/suite_generator.rb` file by adding a version-specific
exception.

# Unusual Implementation Details

While code in this Test Kit is intended to be as simple and as easy-to-understand
as possible, sometimes unanticipated testing requirements are introduced that
require special handling by the US Core test kit.  The ability for Inferno
to accommodate these requirements is a key feature of the Inferno framework.  However,
this does add complexity to maintenance of the tests.

The following is a list of unusual or unorthodox methods used in the US Core
Test Kit that that maintainers should be aware of.  These are also opportunities
for improvement of the Inferno Framework if this type of functionality would be
of broad use beyond US Core.

The following links are to a specific snapshot in time of the repository; this
list should be maintained as the repository evolves.

* All uses of scratch 

* Add a test to a nested group -  [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/custom_groups/base_smart_granular_scopes_group.rb#L144)

* Replace nested groups - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/custom_groups/v7.0.0/smart_app_launch_group.rb#L9-L13) 

* Extract elements from FHIR resources - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/fhir_resource_navigation.rb)

* Extract FHIR resources from requests - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/granular_scope.rb#L40-L60)

* Check whether a resource is valid without adding validation messages  - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/reference_resolution_test.rb#L167-L186)

* Check whether a resource matches search params  - [link](
    https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/resource_search_param_checker.rb)

* Retrieve all Bundle pages  - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/search_test.rb#L549 )

* Find a possible value for a search parameter from a resource  - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/search_test.rb#L601)

* Save resource references to be used by later tests - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/search_test.rb#L690-L710)

* Perform multiple validations without failing early. Only fail at the end if errors were received - [link](https://github.com/inferno-framework/us-core-test-kit/blob/1ecf2146596c884f02e3f5dd5793985d9f29dbb1/lib/us_core_test_kit/validation_test.rb#L18-L25 )