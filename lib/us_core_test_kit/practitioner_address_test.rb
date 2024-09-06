module USCoreTestKit
  module PractitionerAddressTest
    include MustSupportTest, SearchTest

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
      practitioner_ids = get_practitioner_ids(references)

      assert practitioner_ids.present?, "No Pracitioner id found."

      missing_element_set = MUST_SUPPORT_ELEMENTS.to_set
      practitioners = []

      practitioner_ids.each do |p_id|
        fhir_read resource_type, p_id
        assert_response_status(200)
        assert_resource_type(resource_type)
        practitioners << resource

        missing_elements = find_missing_elements([resource], MUST_SUPPORT_ELEMENTS)
        missing_element_set &= missing_elements.to_set

        break if missing_element_set.empty?
      end

      missing_elements_string = missing_element_set.map { |element| missing_element_string(element) }
      support_practitioner_role = false

      if missing_elements.any?
        pr_resource_type = 'PractitionerRole'
        support_practitioner_role = practitioners.any? do |practitioner|
          search_params = { practitioner: practitioner.id }

          search_and_check_response(search_params, pr_resource_type)

          practitioner_roles = fetch_all_bundled_resources(resource_type: pr_resource_type)
            .select { |resource| resource.resourceType == pr_resource_type }

          validator = find_validator(:default)
          target_profile_with_version =  "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole|#{metadata.profile_version}"

          practitioner_roles.any? do |pr|
            validator_response = validator.validate(pr, target_profile_with_version)
            outcome = validator.operation_outcome_from_hl7_wrapped_response(validator_response)
            message_hashes = outcome.issue&.map { |issue| validator.message_hash_from_issue(issue, pr) } || []
            message_hashes.none? { |message_hash| message_hash[:type] == 'error' }
          end
        end
      end


      messages = []
      messages << "US Core PractitionerRole Profile resources" unless support_practitioner_role
      messages << "these MustSupport elements #{missing_elements_string} in US Core Practitioner Profile resources" if missing_element_set.any?

      assert messages.length < 2, "Could not find #{messages.join(' and ')}. Please use patients with more information."
    end

    def get_practitioner_ids(references)
      references.map { |reference| reference.reference&.split('/').last }.compact.uniq
    end
  end
end
