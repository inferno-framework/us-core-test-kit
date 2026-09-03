module USCoreTestKit
  # Regular expressions used to escape and unescape FHIR search parameter values.
  # https://hl7.org/fhir/R4/search.html#escaping
  module FHIRSearchEscaping
    # The characters `\`, `|`, `$`, and `,` have special meaning within a FHIR
    # search parameter value, so when they appear as part of an actual value
    # they must be escaped by prepending a backslash.
    SPECIAL_CHARACTERS = /[\\|$,]/.freeze

    UNESCAPED = /(?<!(?<!\\)\\)/.freeze

    # A `|` which separates the system from the code in a token search value, as
    # opposed to one escaped as `\|` because it is part of a value.
    UNESCAPED_PIPE = /#{UNESCAPED}\|/.freeze
  end
end
