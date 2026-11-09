require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV900
    class DocumentReferencePatientCategoryDateSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for DocumentReference search by patient + category + date'
      description %(
A server SHALL support searching by
patient + category + date on the DocumentReference resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU9/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_9.0.0@51',
                            'hl7.fhir.us.core_9.0.0@52',
                            'hl7.fhir.us.core_9.0.0@55',
                            'hl7.fhir.us.core_9.0.0@58',
                            'hl7.fhir.us.core_9.0.0@61',
                            'hl7.fhir.us.core_9.0.0@62'

      id :us_core_v900_document_reference_patient_category_date_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DocumentReference',
        search_param_names: ['patient', 'category', 'date'],
        possible_status_search: true,
        token_search_params: ['category'],
        params_with_comparators: ['date']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      # Keep the category (including its system) and date from the same document.
      # A clinical note without a date may precede a dated ADI document.
      def search_params_with_values(names, patient_id, include_system: false)
        document = scratch_resources_for_patient(patient_id).find do |candidate|
          search_param_names.all? do |name|
            patient_id_param?(name) || search_param_value(name, candidate).present?
          end
        end
        return super unless document

        names.to_h do |name|
          value = patient_id_param?(name) ? patient_id : search_param_value(name, document, include_system: include_system)
          [name, value]
        end
      end

      run do
        run_search_test
      end
    end
  end
end
