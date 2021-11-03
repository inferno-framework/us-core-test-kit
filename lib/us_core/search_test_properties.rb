module USCore
  class SearchTestProperties
    ATTRIBUTES = [
      :resource_type,
      :search_param_names,
      :first_search,
      :fixed_value_search,
      :saves_delayed_references
    ].freeze

    ATTRIBUTES.each { |name| attr_reader name }

    def initialize(**properties)
      properties.each do |key, value|
        raise StandardError, "Unkown search test property: #{key}" unless ATTRIBUTES.include?(key)

        instance_variable_set(:"@#{key}", value)
      end
    end

    def first_search?
      !!first_search
    end

    def fixed_value_search?
      !!fixed_value_search
    end

    def saves_delayed_references?
      !!saves_delayed_references
    end
  end
end
