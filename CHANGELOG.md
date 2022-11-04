# 0.4.1

* Fix a bug which prevented slices by binding from being correctly identified in
  MustSupport tests (only affects US Core 5) (#88).
* Remove DocumentReference.custodian from the MustSupport test in US Core 3.1.1
  (#84).

# 0.4.0

* Update to a new version of inferno_core based on Ruby 3 (#83).
* Fix a bug caused by escaped commas in search parameters (#85).
* Add support for `fhir_validator_wrapper` version 2.2.0 (#86).

# 0.3.2

* Fix MustSupport requirements for representing a Patient's previous name in US
  Core 4 & 5.
* Fix date comparator searches to account for server time zones.

# 0.3.1

* Fix a typo when no resources are found.
* Prevent validation errors from appearing on reference resolution tests.
* Add optional group for QuestionnaireResponse in US Core 5.
* Fix a nil-safety issue in reference resolution tests.
* Remove QuestionnaireResponse from the list of Must Support target profiles for
  US Core Observation Survey and US Core SDOH Assessment (US Core 5).
* Fix a bug which incorrectly marked SmokingStatus searches by patient +
  category + date as optional (US Core 4 & 5).

# 0.3.0

* Add US Core v5.0.1 tests.

# 0.2.5

* Include the profile version in validation calls so a single validator instance
  can be used for multiple US Core versions.
* Fix a bug where incorrect resources were being checked in searches with
  comparators.
* Remove USCDI-only label from subfields of Patient.telecom and
  Patient.communication (US Core 4+).
* Add Must Support test for dateTime slices (US Core 5+).

# 0.2.4

* Add info message when resource with an unexpected type is included in the
  Bundle response to a search.
* Update validation message filters.

# 0.2.3

* Update testing logic for Patient's previous name MustSupport test.
* Separate USCDI requirements into 'Additional USCDI requirements' section.
* Fix logic in search test when generating search values for Encounter status search.
* Add logic for increased date and time precision in date search tests.
* Remove validation of resource types returned in the Bundles returned by search requests.
* Allow search value extraction from array element when first item is DAR extension.
* Remove US Core Organization Profile from must support checking of Provenance.agent.who.
* Improve search value generation by extracting values from one resource, if possible.
* Alter device search to filter returned resources by Device Type Code input.

# 0.2.2

* Omit medication resource validation if no medication resources provided.
* Fix failure when Clinical Note Reference test finds non-matched reference.
* Update Clinical Note Type test to not save attachment without url and filter DiagnosticReport with required categories only.

# 0.2.1

* Update reference resolution test descriptions in groups to describe the new
  behavior from v0.2.0.
* Remove reference resolution tests for resources with no Must Support
  references.

# 0.2.0

* Add US Core v4.0.0 tests.
* Modify reference resolution tests to only check Must Support references.
* Update reference resolution test to store requests.
* Fix string interpolation in reference search checks.
* Fix error message in read tests when id does not match.

# 0.1.1

* Add .yml files to published gem.
# 0.1.0

* Initial public release.
