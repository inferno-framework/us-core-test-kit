require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class CarePlanPatientCategoryStatusDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by patient + category + status + date'
    description %(
A server SHOULD support searching by
patient + category + status + date on the CarePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_care_plan_patient_category_status_date_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'CarePlan',
        search_param_names: ['patient', 'category', 'status', 'date'],
        token_search_params: ['category'],
        params_with_comparators: ['date']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
