require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PatientBirthdateNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by birthdate + name'
    description %(
A server SHALL support searching by
birthdate + name on the Patient resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :patient_birthdate_name_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Patient',
        search_param_names: ['birthdate', 'name']
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
