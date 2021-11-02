require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PatientBirthdateNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by birthdate + name'
    description %(
      A server SHALL support searching by birthdate + name on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient_birthdate_name_search_test

    def resource_type
      'Patient'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:patient_resources] ||= []
    end

    def search_param_names
      ['birthdate', 'name']
    end

    run do
      perform_search_test
    end
  end
end
