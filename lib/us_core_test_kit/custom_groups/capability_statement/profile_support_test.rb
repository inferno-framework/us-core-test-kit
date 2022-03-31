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
      ```
    )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_resources =
        capability_statement.rest
          &.each_with_object([]) do |rest, resources|
            rest.resource.each { |resource| resources << resource.type }
          end.uniq
      supported_profiles =
        capability_statement.rest
          &.flat_map(&:resource)
          &.flat_map { |resource| resource.supportedProfile + [resource.profile] }
          &.compact || []
      supported_profiles.map! { |profile_url| profile_url.split('|').first }

      assert supported_resources.include?('Patient'), 'US Core Patient profile not supported'

      target_profiles = config.options[:target_profiles]

      other_resources = target_profiles.keys.reject { |resource_type| resource_type == 'Patient' }
      other_resources_supported = other_resources.any? { |resource| supported_resources.include? resource }
      assert other_resources_supported, 'No US Core resources other than Patient are supported'

      target_profiles.each do |resource_type, profiles|
        next unless supported_resources.include? resource_type

        profiles.each do |profile|
          warning do
            assert supported_profiles&.include?(profile),
                    "CapabilityStatement does not claim support for US Core #{resource_type} profile: #{profile}"
          end
        end
      end
    end
  end
end
