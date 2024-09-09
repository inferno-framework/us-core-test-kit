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
      assert references.any?, 'No Pracitioner references found.'

      @missing_elements = MUST_SUPPORT_ELEMENTS
      practitioners = []

      references.each do |reference|
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

          validator = find_validator(:default)
          target_profile_with_version = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole|#{metadata.profile_version}"

          practitioner_roles.any? do |pr|
            validator_response = validator.validate(pr, target_profile_with_version)
            outcome = validator.operation_outcome_from_hl7_wrapped_response(validator_response)
            message_hashes = outcome.issue&.map { |issue| validator.message_hash_from_issue(issue, pr) } || []
            message_hashes.none? { |message_hash| message_hash[:type] == 'error' }
          end
        end
      end

      messages = []
      messages << 'US Core PractitionerRole Profile resources' unless support_practitioner_role
      if @missing_elements.any?
        messages << "these MustSupport elements #{missing_elements_string.join(', ')} in US Core Practitioner Profile resources"
      end

      assert messages.length < 2, "Could not find #{messages.join(' and ')}. Please use patients with more information."
    end

    def get_practitioner_ids(references)
      references.map { |reference| reference.reference&.split('/')&.last }.compact.uniq
    end
  end
end
