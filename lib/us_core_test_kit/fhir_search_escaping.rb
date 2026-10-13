module USCoreTestKit
  # Escapes and unescapes FHIR search parameter values.
  # https://hl7.org/fhir/R4/search.html#escaping
  module FHIRSearchEscaping
    # The characters `\`, `|`, `$`, and `,` have special meaning within a FHIR
    # search parameter value, so when they appear as part of an actual value
    # they must be escaped by prepending a backslash.
    SPECIAL_CHARACTERS = /[\\|$,]/.freeze

    # Handle arbitrary number of backslashes: odd number is escaped, even is unescaped 
    # Use the "consume complete backslash pairs, then check the delimiter" idiom, 
    # using \K to discard the consumed pairs from the match
    UNESCAPED = /(?<!\\)(?:\\\\)*\K/.freeze

    # A `|` which separates the system from the code in a token search value, as
    # opposed to one escaped as `\|` because it is part of a value.
    UNESCAPED_PIPE = /#{UNESCAPED}\|/.freeze

    UNESCAPED_DELIMITER_PATTERNS = Hash.new do |patterns, delimiter|
      patterns[delimiter] = /#{UNESCAPED}#{Regexp.escape(delimiter)}/.freeze
    end

    def escape_search_value(value)
      value&.gsub(SPECIAL_CHARACTERS) { |character| "\\#{character}" }
    end

    def unescape_search_value(value)
      value&.gsub(/\\(.)/m) { Regexp.last_match(1) }
    end

    # Build a token search value, escaping the system and code so that any
    # special characters they contain are not mistaken for the unescaped `|`
    # that separates the system from the code.
    def token_search_value(system, code, include_system)
      return escape_search_value(code) unless include_system

      "#{escape_search_value(system)}|#{escape_search_value(code)}"
    end

    def parse_escaped_token(escaped_search_value)
      system, code = escaped_search_value.split(UNESCAPED_PIPE, 2)
      [unescape_search_value(system), unescape_search_value(code)]
    end

    # Split an escaped search value on the unescaped occurrences of `delimiter`,
    # then unescape each of the resulting values.
    def split_escaped_search_value(escaped_search_value, delimiter)
      escaped_search_value
        .split(UNESCAPED_DELIMITER_PATTERNS[delimiter])
        .map { |value| unescape_search_value(value) }
    end
  end
end
