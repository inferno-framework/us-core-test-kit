# frozen_string_literal: true

module USCoreTestKit
  module PractitionerAddressTest
    include SearchTest
    include ReferenceResolutionTest
    include MustSupportTest

    MUST_SUPPORT_ELEMENTS = [
      { path: 'address' },
      { path: 'address.line' },
      { path: 'address.city' },
      { path: 'address.state' },
      { path: 'address.postalCode' },
      { path: 'address.country' }
    ].freeze

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resource] ||= {}
    end

    def verify_practitioner_address
      references = scratch.dig(:references, 'Practitioner')
      assert references&.any?, 'No Practitioner references found.'

      @missing_elements = MUST_SUPPORT_ELEMENTS
      practitioners = []

      references.each do |reference_info|
        reference = reference_info[:reference]
        resolved_resource = resolve_reference(reference)

        if resolved_resource.nil? ||
           resolved_resource.resourceType != resource_type ||
           resolved_resource.id != reference.reference_id
          next
        end

        practitioners << resolved_resource

        some_missing_elements = find_missing_elements([resolved_resource], MUST_SUPPORT_ELEMENTS)
        @missing_elements &= some_missing_elements

        break if @missing_elements.empty?
      end

      missing_elements_string = @missing_elements.map { |element| missing_element_string(element) }
      support_practitioner_role = false

      if @missing_elements.any?
        resource_type = 'PractitionerRole'
        support_practitioner_role = practitioners.any? do |practitioner|
          search_params = { practitioner: practitioner.id }

          search_and_check_response(search_params, resource_type)

          practitioner_roles = fetch_all_bundled_resources(resource_type:)
            .select { |resource| resource.resourceType == resource_type }

          next false if practitioner_roles.empty?
          next true if config.options[:skip_practitioner_role_validation]

          target_profile_with_version =
            "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole|#{metadata.profile_version}"

          practitioner_roles.any? { |pr| resource_is_valid_with_target_profile?(pr, target_profile_with_version) }
        end
      end

      missing_must_support_message = 'Could not find US Core PractitionerRole Profile resources and ' \
                                     "these MustSupport elements #{missing_elements_string.join(', ')} " \
                                     'in US Core Practitioner Profile resources. ' \
                                     'Please use patients with more information.'

      assert (support_practitioner_role || @missing_elements.blank?), missing_must_support_message
    end

    def get_practitioner_ids(references)
      references.map { |reference| reference.reference&.split('/')&.last }.compact.uniq
    end
  end
end
