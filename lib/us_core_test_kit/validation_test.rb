module USCoreTestKit
  module ValidationTest
    DAR_CODE_SYSTEM_URL = 'http://terminology.hl7.org/CodeSystem/data-absent-reason'.freeze
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze

    def perform_validation_test(resources,
                                profile_url,
                                must_demonstrate_resource_type: true)

      skip_if must_demonstrate_resource_type && resources.blank?,
              "No #{resource_type} resources conforming to the #{profile_url} profile were returned"

      omit_if resources.blank?,
              "No #{resource_type} resources provided so the #{profile_url} profile does not apply"

      resources.each do |resource|
        resource_is_valid?(resource: resource, profile_url: profile_url)
        check_for_dar(resource)
      end

      errors_found = messages.any? { |message| message[:type] == 'error' }

      assert !errors_found, "Resource does not conform to the profile #{profile_url}"
    end

    def check_for_dar(resource)
      unless scratch[:dar_code_found]
        resource.each_element do |element, meta, _path|
          next unless element.is_a?(FHIR::Coding)

          check_for_dar_code(element)
        end
      end

      unless scratch[:dar_extension_found]
        check_for_dar_extension(resource)
      end
    end

    def check_for_dar_code(coding)
      return unless coding.code == 'unknown' && coding.system == DAR_CODE_SYSTEM_URL

      scratch[:dar_code_found] = true
      output dar_code_found: 'true'
    end

    def check_for_dar_extension(resource)
      return unless resource.source_contents&.include? DAR_EXTENSION_URL

      scratch[:dar_extension_found] = true
      output dar_extension_found: 'true'
    end
  end
end
