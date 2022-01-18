require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PatientBirthdateFamilySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by birthdate + family'
    description %(
A server SHOULD support searching by
birthdate + family on the Patient resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_patient_birthdate_family_search_test

    def self.properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Patient',
        search_param_names: ['birthdate', 'family']
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
