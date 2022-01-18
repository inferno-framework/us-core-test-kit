require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PatientGenderNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by gender + name'
    description %(
A server SHALL support searching by
gender + name on the Patient resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_patient_gender_name_search_test

    def self.properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Patient',
        search_param_names: ['gender', 'name']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:patient_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
