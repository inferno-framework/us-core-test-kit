module USCoreTestKit
  module PractitionerAddressTest
    include ReadTest, MustSupportTest, SearchTest

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resource] ||= {}
    end

    def verify_practitioner_address
      practitioner_references = scratch.dig(:references, 'Practitioner')
      binding.pry
      resources_to_read = readable_resources(practitioner_references)

      assert resources_to_read.present?, "No Pracitioner id found."

      resources_to_read.each { |r| read_and_validate(r) }

      practitioners = all_scratch_resources

      assert practitioners.any?, "No Practitioner read from server."

      must_support_elements = [
        { path: 'address' },
        { path: 'address.line' },
        { path: 'address.city' },
        { path: 'address.state' },
        { path: 'address.postalCode' },
        { path: 'address.country' }
      ].freeze

      missing_elements = find_missing_elements(practitioners, must_support_elements )
      missing_elements_string = missing_elements.map { |element| missing_element_string(element) }
      support_practitioner_role = false

      if missing_elements.any?
        resource_type = 'PracitionerRole'
        support_practitioner_role = practitioners.any? do |practitioner|
          search_params = { practitioner: practitioner.id }

          binding.pry
          search_and_check_response(search_params, resource_type)

          practitioner_roles = fetch_all_bundled_resources(resource_type:)
            .select { |resource| resource.resourceType == resource_type }

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
      messages << "these MustSupport elements #{missing_elements_string} in US Core Practitioner Profile resources" if missing_elements.any?

      assert messages.length < 2, "Could not find #{messages.join(' and ')}. Please use patients with more information."
    end
  end
end
