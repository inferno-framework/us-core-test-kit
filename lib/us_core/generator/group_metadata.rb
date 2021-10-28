module USCore
  class Generator
    class GroupMetadata
      ATTRIBUTES = [
        :name,
        :class_name,
        :version,
        :reformatted_version,
        :resource,
        :profile_url,
        :profile_name,
        :title,
        :interactions,
        :operations,
        :searches,
        :search_definitions,
        :include_params,
        :revincludes,
        :required_concepts,
        :must_supports,
        :mandatory_elements,
        :bindings,
        :references,
      ].freeze

      ATTRIBUTES.each { |name| attr_reader name }

      def initialize(**params)
        params.each do |key, value|
          raise "Unknown attribute #{key}" unless ATTRIBUTES.include? key

          instance_variable_set(:"@#{key}", value)
        end
      end

      def to_hash
        ATTRIBUTES.each_with_object({}) { |key, hash| hash[key] = send(key) }
      end
    end
  end
end
