module USCoreTestKit
  class ProfileSupportTest < Inferno::Test
    id :us_core_profile_support
    title 'Capability Statement lists support for required US Core Profiles'
    description %(
      The US Core Implementation Guide states:

      ```
      The US Core Server SHALL:
      1. Support the US Core Patient resource profile.
      2. Support at least one additional resource profile from the list of US
         Core Profiles.

      In order to support USCDI, servers must support all USCDI resources.
      ```
    )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_profiles = capability_statement.rest&.flat_map do |rest|
        rest.resource.flat_map do |resource|
          # Remove trailing version from canonical url
          resource.supportedProfile&.map { |profile| profile.split('|').first }
        end.compact
      end&.uniq || []

      assert supported_profiles.include?('http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'),
             'US Core Patient profile not supported'

      us_core_profiles = config.options[:us_core_profiles]

      other_profiles = us_core_profiles.reject { |resource_type| resource_type == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient' }
      other_profiles_supported = other_profiles.any? { |profile| supported_profiles.include? profile }
      assert other_profiles_supported, 'No US Core profiles other than Patient are supported'

      if config.options[:required_profiles].present?
        required_profiles = config.options[:required_profiles]

        missing_profiles = required_profiles - supported_profiles

        missing_profiles_list =
          missing_profiles
            .map { |resource| "`#{resource}`" }
            .join(', ')

        assert missing_profiles.empty?,
               'The CapabilityStatement does not list support for the following' \
               "US Core profiles: #{missing_profiles_list}"
      end
    end
  end
end
