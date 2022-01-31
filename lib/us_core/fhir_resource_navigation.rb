module USCore
  module FHIRResourceNavigation
    def resolve_path(elements, path)
      elements = Array.wrap(elements)
      return elements if path.blank?

      paths = path.split('.')
      segment = paths.first
      remaining_path = paths.drop(1).join('.')

      elements.flat_map do |element|
        child = get_next_value(element, segment)
        resolve_path(child, remaining_path)
      end.compact
    end

    def find_a_value_at(element, path)
      return nil if element.nil?

      elements = Array.wrap(element)

      if path.empty?
        return elements.find { |el| yield(el) } if block_given?

        return elements.first
      end

      path_segments = path.split('.')
      segment = path_segments.shift.delete_suffix('[x]').to_sym

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
            find_a_value_at(child, remaining_path) { |value_found| yield(value_found) }
          else
            find_a_value_at(child, remaining_path)
          end

        return element_found if element_found.present? || element_found == false
      end

      nil
    end

    def get_next_value(element, property)
      element.send(property)
    rescue NoMethodError
      nil
    end
  end
end
