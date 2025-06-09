The US Core Test Kit includes client suites for several versions of US Core.
These tests include a simulation of a US Core server that can return US Core data in
response to client requests, including conformant data for all US Core profiles.
During the tests, clients will interact with the simulated server and Inferno
will verify the interactions.

The US Core Client Test Suites serve two purposes:
* Provide general testing to servers implementing the US Core Implementation Guide
* Provide tests to other test kits that target other implementation guides, or
certification criterion, that may reference US Core.

This guide targets users who would like to run the US Core Test Kit outside
the context of another Implementation Guide or certification criterion.

## Testing Options

Users of the server test suites are presented with two options:

* Which version of the US Core Implementation Guide to test against
* Whether and how the client will authenticate with Inferno using the
  SMART App Launch OAuth flow

Inferno's SMART App Launch simulation is still immature, but has been shown
to work with SMART v1.0.0, SMART v2.0.0, and SMART v2.2.0 clients. Testers
do not need to tell Inferno which version to use.

## Test Prerequisites

The client suites require client systems to demonstrate access of specific
resources hosted by and available through the suite. Testers may need
to pre-register a patient with the following demographics in the client system:
- **Name**: ClientTests USCore
- **Member Identifier**: `us-core-client-tests-patient` (system: `urn:inferno:mrn`)
- **Date of Birth**: 1940-03-29
- **Gender**: male

This corresponds to the Patient with id `us-core-client-tests-patient` on Inferno's simulated
US Core Server. This patient has conformant data for each US Core profile.

## Conformance Criteria

Systems do NOT need to pass all tests within this test kit to be considered 'US
Core Conformant'. US Core allows systems to support a subset of content
relevant to their use case. The US Core Client Suites allow testers to run
all the tests, or only evaluate access for a subset of profiles that the
client supports. In either case, when running a profile group and
the client has not made any requests for data for that profile's resource
type, the tests will be skipped.

## Test Groups

The client suites are organized into the following high-level test groups.

### 1 Client Registration

This group must be run first for each session to establish the client's registration
with Inferno's simulated US Core server. Testers will provide inputs needed for
Inferno to register the client and Inferno will
- Evaluate those inputs for conformance
- Display connection details to the tester for them to use in configuring the
  client to connect to Inferno.

### 2 Read & Search

This group contains the majority of the US Core client tests. Execution involves a two-step
process where
- Inferno waits while the client makes requests to access data on Inferno's simulated
  US Core server.
- Once the tester indicates they are done, Inferno evaluates the requests made
  againsts the requirements for each profile.

These two steps can be run together by running the Read & Search group, or testers
can choose to evaluate only a subset of the profiles defined by the selected US Core
version by first running the Client Access subgroup followed by any number of profile
groups. In either case, testers may run this sequence over and over
again to evaluate different sets of client requests. When executing a profile group,
Inferno will consider only requests that were made during the last run of the Client Access
group (NOTE: data access requests can also be made during the registration display
test. If any such requests were made during the last execution of that test, they will
also be included in the analysis performed by a profile group).