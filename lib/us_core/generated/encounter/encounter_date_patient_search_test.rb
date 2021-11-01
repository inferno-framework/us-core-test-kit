require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class EncounterDatePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by date + patient'
    description %(
      A server SHALL support searching by date + patient on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_date_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'Encounter'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:encounter_resources] ||= []
    end

    def search_params
      {
        'date': search_param_value('period'),
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
