require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ConditionPatientOnsetDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by patient + onset-date'
    description %(
A server SHOULD support searching by
patient + onset-date on the Condition resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_condition_patient_onset_date_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def self.properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Condition',
        search_param_names: ['patient', 'onset-date'],
        params_with_comparators: ['onset-date']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:condition_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
