require_relative 'fhir_resource_navigation'
require_relative 'fhir_search_escaping'

module USCoreTestKit
  module ResourceSearchParamChecker
    include Inferno::DSL::FHIRResourceNavigation

    def search_param_paths(name)
      paths = metadata.search_definitions[name.to_sym][:paths]
      if paths.first =='class'
        paths[0] = 'local_class'
      end

      paths
    end

    def element_has_valid_value?(element, include_system)
      case element
      when FHIR::Reference
        element.reference.present?
      when FHIR::CodeableConcept
        if include_system
          coding =
            find_a_value_at(element, 'coding') { |coding| coding.code.present? && coding.system.present? }
          coding.present?
        else
          find_a_value_at(element, 'coding.code').present?
        end
      when FHIR::Identifier
        include_system ? element.value.present? && element.system.present? : element.value.present?
      when FHIR::Coding
        include_system ? element.code.present? && element.system.present? : element.code.present?
      when FHIR::HumanName
        (element.family || element.given&.first || element.text).present?
      when FHIR::Address
        (element.text || element.city || element.state || element.postalCode || element.country).present?
      when FHIR::Element
        false
      else
        true
      end
    end

    def escape_search_value(value)
      value&.gsub(FHIRSearchEscaping::SPECIAL_CHARACTERS) { |character| "\\#{character}" }
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
      system, code = escaped_search_value.split(FHIRSearchEscaping::UNESCAPED_PIPE, 2)
      [unescape_search_value(system), unescape_search_value(code)]
    end

    # Split an escaped search value on the unescaped occurrences of `delimiter`,
    # then unescape each of the resulting values.
    def split_escaped_search_value(escaped_search_value, delimiter)
      escaped_search_value
        .split(/#{FHIRSearchEscaping::UNESCAPED}#{Regexp.escape(delimiter)}/)
        .map { |value| unescape_search_value(value) }
    end

    def resource_matches_param?(resource, search_param_name, escaped_search_value, values_found = [])
      search_value = unescape_search_value(escaped_search_value)
      paths = search_param_paths(search_param_name)

      match_found = false

      paths.each do |path|
        type = metadata.search_definitions[search_param_name.to_sym][:type]

        resolve_path(resource, path).each do |value|
          values_found <<
            if value.is_a? FHIR::Reference
              value.reference
            elsif value.is_a? Inferno::DSL::PrimitiveType
              value.value
            else
              value
            end
        end

        # delete any nil values from the array so that we don't 
        # have to check for nil when validating the search value
        values_found.compact!
        
        match_found =
          case type
          when 'Period', 'date', 'instant', 'dateTime'
            values_found.any? { |date| validate_date_search(search_value, date) }
          when 'HumanName'
            # When a string search parameter refers to the types HumanName and Address,
            # the search covers the elements of type string, and does not cover elements such as use and period
            # https://www.hl7.org/fhir/search.html#string
            search_value_downcase = search_value.downcase
            values_found.any? do |name|
              name&.text&.downcase&.start_with?(search_value_downcase) ||
                name&.family&.downcase&.start_with?(search_value_downcase) ||
                name&.given&.any? { |given| given.downcase.start_with?(search_value_downcase) } ||
                name&.prefix&.any? { |prefix| prefix.downcase.start_with?(search_value_downcase) } ||
                name&.suffix&.any? { |suffix| suffix.downcase.start_with?(search_value_downcase) }
            end
          when 'Address'
            search_value_downcase = search_value.downcase
            values_found.any? do |address|
              address&.text&.downcase&.start_with?(search_value_downcase) ||
                address&.city&.downcase&.start_with?(search_value_downcase) ||
                address&.state&.downcase&.start_with?(search_value_downcase) ||
                address&.postalCode&.downcase&.start_with?(search_value_downcase) ||
                address&.country&.downcase&.start_with?(search_value_downcase)
            end
          when 'CodeableConcept'
            # FHIR token search (https://www.hl7.org/fhir/search.html#token): "When in doubt, servers SHOULD
            # treat tokens in a case-insensitive manner, on the grounds that including undesired data has
            # less safety implications than excluding desired behavior".
            codings = values_found.flat_map(&:coding)
            if escaped_search_value&.match?(FHIRSearchEscaping::UNESCAPED_PIPE)
              system, code = parse_escaped_token(escaped_search_value)
              codings&.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
            else
              codings&.any? { |coding| coding.code&.casecmp?(search_value) }
            end
          when 'Coding'
            if escaped_search_value&.match?(FHIRSearchEscaping::UNESCAPED_PIPE)
              system, code = parse_escaped_token(escaped_search_value)
              values_found.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
            else
              values_found.any? { |coding| coding.code&.casecmp?(search_value) }
            end
          when 'Identifier'
            if escaped_search_value&.match?(FHIRSearchEscaping::UNESCAPED_PIPE)
              system, value = parse_escaped_token(escaped_search_value)
              values_found.any? { |identifier| identifier.system == system && identifier.value == value }
            else
              values_found.any? { |identifier| identifier.value == search_value }
            end
          when 'string'
            searched_values = split_escaped_search_value(escaped_search_value, ',').map(&:downcase)
            values_found.any? do |value_found|
              searched_values.any? { |searched_value| value_found.downcase.starts_with? searched_value }
            end
          else
            # searching by patient requires special case because we are searching by a resource identifier
            # references can also be URLs, so we may need to resolve those URLs
            if ['subject', 'patient'].include? search_param_name.to_s
              id = search_value.split('Patient/').last
              possible_values = [id, "Patient/#{id}", "#{url}/Patient/#{id}"]
              values_found.any? do |reference|
                possible_values.include? reference
              end
            else
              search_values = split_escaped_search_value(escaped_search_value, ',')
              values_found.any? { |value_found| search_values.include? value_found }
            end
          end

        break if match_found
      end

      match_found
    end
    
  end
end
