require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DiagnosticReportLabStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by status'
    description %(
      A server MAY support searching by status on the DiagnosticReport resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :diagnostic_report_lab_status_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'DiagnosticReport',
        search_param_names: ['status']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:diagnostic_report_lab_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
