require_relative 'generated/resource_list'
require_relative 'fhir_resource_navigation'

module USCoreTestKit
  module ReferenceResolutionTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def perform_reference_resolution_test(resources)
      skip_if resources.blank?, no_resources_skip_message

      if unresolved_references(resources).length.zero?
        pass
      end

      skip "Could not resolve Must Support references #{unresolved_references_strings.join(', ')}"
    end

    def unresolved_references_strings
      unresolved_references.map { |element_definition| element_definition[:path]}
    end

    def record_resolved_reference(reference)
      resolved_references.add?(reference.reference)
    end

    def resolved_references
      scratch[:resolved_references] ||= Set.new
    end

    def no_resources_skip_message
      "No #{resource_type} resources appeart to be available. " \
      'Please use patients with more information.'
    end

    def must_support_references
      metadata.must_supports[:elements].select{ |element_definition| element_definition[:type].any? { |type| type == 'Reference'} }
    end

    def unresolved_references(resources = [])
      @unresolved_references ||=
        must_support_references.select do |element_definition|
          path = element_definition[:path]

          found_one_reference = false

          resolve_one_reference = resources.any? do |resource|
            value_found = find_a_value_at(resource, path) do |value|
              value.class == FHIR::Reference
            end

            next if value_found.nil?

            found_one_reference = true

            validate_reference_resolution(resource, value_found)
          end

          found_one_reference && !resolve_one_reference
        end
    end

    def validate_reference_resolution(resource, reference)
      return true if resolved_references.include?(reference.reference)

      if reference.contained?
        # if reference_id is blank it is referring to itself, so we know it exists
        return true if reference.reference_id.blank?

        return resource.contained.any? { |contained_resource| contained_resource&.id == reference.reference_id }
      end

      if reference.relative?
        begin
          reference.resource_class
        rescue NameError
          return false
        end
      end
        
      reference_type = reference.resource_type

      begin
        # TODO: this request isn't persisted
        resolved_resource = reference.read(fhir_client)
      rescue ClientException 
        return false
      end

      if resolved_resource&.resourceType == reference_type
        record_resolved_reference(reference)
        return true
      else
        return false
      end
    end
  end
end
