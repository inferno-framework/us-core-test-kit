module USCoreTestKit
  class Generator
    class VerifiesRequirements

      attr_accessor :requirement_lists
      
      V610 = 'USCoreV610'
      V700 = 'USCoreV700'
      V800 = 'USCoreV800'

      MIN_VERSION = V610

      MODULE_NAMESPACE_MAP = {
        V610 => 'hl7.fhir.us.core_6.1.0',
        V700 => 'hl7.fhir.us.core_7.0.0',
        V800 => 'hl7.fhir.us.core_8.0.0'
      }.freeze

      def initialize
        @requirement_lists = {
          V610 => {
            :base => [],
            :map => {},
            :remove => []
          },
          V700 => {
            :base => [],
            :map => {},
            :remove => []
          },
          V800 => {
            :base => [],
            :map => {},
            :remove => []
          }
        }
      end

      def get_ids(module_name, class_name)
        if module_name < MIN_VERSION
          return
        end

        all_ids = []

        if module_name >= V610
          all_ids += @requirement_lists[V610][:base]
          all_ids += @requirement_lists[V610][:map][class_name] if @requirement_lists[V610][:map][class_name]
          all_ids -= @requirement_lists[V610][:remove]
        end

        if module_name >= V700
          all_ids += @requirement_lists[V700][:base]
          all_ids += @requirement_lists[V700][:map][class_name] if @requirement_lists[V700][:map][class_name]
          all_ids -= @requirement_lists[V700][:remove]
        end

        if module_name >= V800
          all_ids += @requirement_lists[V800][:base]
          all_ids += @requirement_lists[V800][:map][class_name] if @requirement_lists[V800][:map][class_name]
          all_ids -= @requirement_lists[V800][:remove]
        end

        all_ids
      end

      def create_verifies_requirements(module_name, class_name, indent_spaces = 6)
        if module_name < MIN_VERSION
          return
        end

        ids = get_ids(module_name, class_name)
        create_verifies_requirements_from_ids(module_name, ids, indent_spaces) if ids.any?
      end

      def create_verifies_requirements_from_ids(module_name, ids, indent_spaces = 6)
        if module_name < MIN_VERSION
          return
        end

        namespace = MODULE_NAMESPACE_MAP[module_name]
        verifies_requirements = ' ' * indent_spaces + "verifies_requirements "
        indent_spaces = verifies_requirements.length
        verifies_requirements += ids.map.with_index do |id, i|
          "'#{namespace}@#{id}'" + (i < ids.size - 1 ? ',' : '')
        end.join("\n" + ' ' * indent_spaces)

        verifies_requirements
      end

      def has_requirements?(module_name, class_name)
        return false if module_name < V610

        ids = get_ids(module_name, class_name)
        ids && ids.any?
      end
    end
  end
end