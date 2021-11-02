require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PediatricBmiForAgePatientCodeDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + code + date'
    description %(
      A server SHOULD support searching by patient + code + date on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_bmi_for_age_patient_code_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:pediatric_bmi_for_age_resources] ||= []
    end

    def search_param_names
      ['patient', 'code', 'date']
    end

    run do
      perform_search_test
    end
  end
end
