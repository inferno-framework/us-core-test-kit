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
