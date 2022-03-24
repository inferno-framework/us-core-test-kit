require_relative 'fhir_resource_navigation'

module USCoreTestKit
  module ReferenceResolutionTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def perform_reference_resolution_test(resources)
      skip_if resources.blank?, no_resources_skip_message

      pass if unresolved_references(resources).length.zero?

      skip "Could not resolve Must Support references #{unresolved_references_strings.join(', ')}"
    end

    def unresolved_references_strings
      unresolved_reference_hash =
        unresolved_references.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |missing, hash|
          hash[missing[:path]] << missing[:target_profile] 
        end
      unresolved_reference_hash.map { |path, profiles| "#{path}#{"(#{profiles.join('|')})" unless profiles.first.empty?}" }
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
      metadata.must_supports[:elements].select { |element_definition| element_definition[:type]&.include?('Reference') }
    end

    def must_support_references_with_target_profile
      must_support_references.map do |element_definition|
        (element_definition[:target_profile] || ['']).map do |target_profile|
          {
            path: element_definition[:path],
            target_profile: target_profile
          }
        end
      end.flatten
    end

    def unresolved_references(resources = [])
      @unresolved_references ||=
        must_support_references_with_target_profile.select do |element_definition|
          path = element_definition[:path]
          target_profile = element_definition[:target_profile]

          found_one_reference = false

          resolve_one_reference = resources.any? do |resource|
            value_found = resolve_path(resource, path)
            next if value_found.empty?

            found_one_reference = true

            value_found.any? do |reference|
              validate_reference_resolution(resource, reference, target_profile)
            end
          end

          found_one_reference && !resolve_one_reference
        end
    end

    def validate_reference_resolution(resource, reference, target_profile)
      return true if resolved_references.include?(reference.reference) && target_profile.empty?

      if reference.contained?
        # if reference_id is blank it is referring to itself, so we know it exists
        return true if reference.reference_id.blank?

        reference_found = resource.contained.any? do |contained_resource|
          contained_resource&.id == reference.reference_id &&
            resource_is_valid_with_target_profile?(contained_resource, target_profiles)
        end
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

      return false unless resolved_resource&.resourceType == reference_type

      return false unless resource_is_valid_with_target_profile?(resolved_resource, target_profile)

      record_resolved_reference(reference)
      true
    end

    def resource_is_valid_with_target_profile?(resource, target_profile)
      return true if target_profile.empty?

      resource_is_valid?(resource: resource, profile_url: target_profile)
    end
  end
end
