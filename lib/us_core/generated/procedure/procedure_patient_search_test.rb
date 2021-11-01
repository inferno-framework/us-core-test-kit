require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ProcedurePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by patient'
    description %(
      A server SHALL support searching by patient on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'Procedure'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:procedure_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
