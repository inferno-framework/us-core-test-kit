module USCore
  module ValidationTest
    def perform_validation_test(resources, profile_url)
      skip_if resources.blank?,
              "No #{resource_type} resources conforming to the #{profile_url} profile were returned."

      resources.each do |resource|
        resource_is_valid?(resource: resource, profile_url: profile_url)
      end

      errors_found = messages.any? { |message| message[:type] == 'error' }

      assert !errors_found, "Resource does not conform to the profile #{profile_url}"
    end
  end
end
