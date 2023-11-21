module USCoreTestKit
  module FHIRResourceNavigation
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze

    def resolve_path(elements, path)
      elements = Array.wrap(elements)
      return elements if path.blank?

      paths = path.split(/(?<!hl7)\./)
      segment = paths.first
      remaining_path = paths.drop(1).join('.')

      elements.flat_map do |element|
        child = get_next_value(element, segment)
        resolve_path(child, remaining_path)
      end.compact
    end

    def find_a_value_at(element, path, include_dar: false)
      return nil if element.nil?

      elements = Array.wrap(element)
      path = (path.include?(':') && !path.include?('url')) ? path.gsub(/:.*\./, '.') : path
      if path.empty?
        unless include_dar
          elements = elements.reject do |el|
            el.respond_to?(:extension) && el.extension.any? { |ext| ext.url == DAR_EXTENSION_URL}
          end
        end

        return elements.find { |el| yield(el) } if block_given?

        return elements.first
      end

      path_segments = path.split(/(?<!hl7)\./)
      segment = path_segments.shift.delete_suffix('[x]').gsub(/^class$/, 'local_class').to_sym

      no_elements_present =
        elements.none? do |element|
        child = get_next_value(element, segment)

        child.present? || child == false
      end

      return nil if no_elements_present

      remaining_path = path_segments.join('.')

      elements.each do |element|
        child = get_next_value(element, segment)
        element_found =
          if block_given?
            find_a_value_at(child, remaining_path, include_dar: include_dar) { |value_found| yield(value_found) }
          else
            find_a_value_at(child, remaining_path, include_dar: include_dar)
          end

        return element_found if element_found.present? || element_found == false
      end

      nil
    end

    def get_next_value(element, property)
      extension_url = property[/(?<=where\(url=').*(?='\))/]

      if extension_url.present?
        element.url == extension_url ? element : nil
      else
        element.send(property)
      end
    rescue NoMethodError
      nil
    end
  end
end
