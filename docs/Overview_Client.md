
The US Core Test Kit provides client testing for several versions of US Core.
Tests are designed to simulate a realistic server that includes conformant data
for all US Core profiles and can return US Core data in response to client requests.

The US Core Client Test Suites serve two purposes:
* Provide general testing to servers implementing the US Core Implementation Guide
* Provide tests to other test kits that target other implementation guides, or
certification criterion, that may reference US Core.

This guide is targeting users who would like to run the US Core Test Kit without
being the context of another Implementation Guide or certification criterion.

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
US Core Server.

## Conformance Criteria

Systems do NOT need to pass all tests within this test kit to be considered 'US
Core Conformant'.  US Core allows systems to support a subset of content
relevant to their use case. While evaluating requests made by the client
the US Core Client Suites will look at all US Core Profiles. However, when
the client makes no requests for data for a particular profile's resource
type, the suite will skip the evaluation and provide no feedback on the
assumption that the client does not support that profile or does not
want to get feedback on it during the current test run.

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

This group contains the majority of the US Core client tests and involve a two-step
process where
- Inferno waits while the client makes requests to access data on Inferno's simulated
  US Core server.
- Once the tester indicates they are done, Inferno evaluates the requests made.

These two steps are always run together. Testers may run the group over and over
again to evaluate different sets of client requests. Each time, Inferno will
consider only requests that were made during the current iteration.