
The US Core Test Kit provides server testing for several versions of US Core.
Tests are designed to simulate a realistic client that would like to access all
data described by US Core using those FHIR API read and search queries that must
be supported.  Like real clients, the tests learn about data on the server and
adjusts future queries based on this information.  In the process, all required
and optional queries are checked.

The US Core Test Kit serves two purposes:
* Provide general testing to servers implementing the US Core Implementation Guide
* Provide tests to other test kits that target other implementation guides, or
certification criterion, that may reference US Core.

This guide is targeting users who would like to run the US Core Test Kit without
being the context of another Implementation Guide or certification criterion.

## Testing Options

Users of the test kit are presented with two options:

* Which version of the US Core Implementation Guide to test against
* Which version of the SMART App Launch Implementation Guide to test against

Because US Core requires support of the SMART App Launch Guide, this set of
tests also include SMART App Launch tests that may be relevant.

Please note that US Core states that at least version SMART App Launch v2.0 is
used in US Core 7; however, these tests allow testers to select SMART App Launch
v1 for any US Core version.

## Test Prerequisites

Systems do not need to load a specific set of data to run these tests.  However,
the tests do require that the system under test has a set of data that is
representative of the data that the system will be handling.

## Conformance Criteria

Systems do NOT need to pass all tests within this test kit o be considered 'US
Core Conformant'.  US Core allows systems to support a subset of content
relevant to their use case.  The US Core Test Kit allows testers to choose which
tests to run, and it is up to the tester to decide which set of tests are
relevant to a given system.  Tests are divided in a logical way that should align
with common boundaries associated with real-world systems; e.g. you may run
tests relevant to a certain profile while skipping tests for other profiles.

## Test Groups

This test kit is organized into the following high-level test groups.  The system
under test can choose which test groups are relevant to their system.


### 1 SMART App Launch

This group provides two tests: an EHR launch test and a standalone launch test,
based on the SMART App Launch guide.  When used, a bearer token is stored
that can be used in the US Core FHIR API test section.

Read the description provided in each test with instructions on their use.

### 2 US Core FHIR API

This group contains the majority of the US Core tests that are applicable to the
US Core Implementation Guide.  Users may either run all tests, or select a
subset of tests based on the relevant to their system.  They are principally organized
by US Core Profiles, and each test group includes both search and read tests
relevant to that profile.

Users may provide a single patient ID or a comma-separated list of patient IDs.
The value of providing multiple patient IDs is that the tests can evaluate
MUST SUPPORT elements across all resources across multiple patients.

**Important**: Due to test design limitations, tests for profiles that do not
directly reference
a patient ID (e.g.; Organization, Practitioner) should not be run individually.
They can only be run when the entire group US Core FHIR API group is run.

### 3 US Core SMART Granular Scopes (US Core v6+, SMART App Launch v2+)

This group tests the specific implementation details surrounding use of granular
SMART App Launch scopes within US Core.