module USCoreTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = [
        'Location',
        'Medication',
        'PractitionerRole',
        'QuestionnaireResponse'
      ].freeze

      PROFILES_TO_EXCLUDE = [
        'us_core_vital_signs'
      ].freeze

      class << self
        def exclude_resource?(resource)
          RESOURCES_TO_EXCLUDE.include? resource
        end

        def exclude_group?(group)
          RESOURCES_TO_EXCLUDE.include?(group.resource) ||
          PROFILES_TO_EXCLUDE.include?(group.name)
        end
      end
    end
  end
end
