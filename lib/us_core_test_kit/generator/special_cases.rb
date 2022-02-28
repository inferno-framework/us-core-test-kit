module USCoreTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = [
        'Location',
        'Medication',
        'PractitionerRole'
      ].freeze

      class << self
        def exclude_resource?(resource)
          RESOURCES_TO_EXCLUDE.include? resource
        end
      end
    end
  end
end
