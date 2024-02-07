require_relative 'document_reference/document_reference_patient_granular_scope_test'
require_relative 'document_reference/document_reference_id_granular_scope_test'
require_relative 'document_reference/document_reference_patient_type_granular_scope_test'
require_relative 'document_reference/document_reference_patient_status_granular_scope_test'
require_relative 'document_reference/document_reference_patient_type_period_granular_scope_test'
require_relative 'document_reference/document_reference_patient_category_date_granular_scope_test'
require_relative 'document_reference/document_reference_patient_category_granular_scope_test'

module USCoreTestKit
  module USCoreV610
    class DocumentReferenceGranularScope1Group < Inferno::TestGroup
      title 'DocumentReference Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core DocumentReference Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `DocumentReference.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category|clinical-note`

      )

      id :us_core_v610_document_reference_granular_scope_1_group
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'document_reference', 'metadata.yml'), aliases: true))
      end
    
      test from: :us_core_v610_DocumentReference_patient_granular_scope_test
      test from: :us_core_v610_DocumentReference__id_granular_scope_test
      test from: :us_core_v610_DocumentReference_patient_type_granular_scope_test
      test from: :us_core_v610_DocumentReference_patient_status_granular_scope_test
      test from: :us_core_v610_DocumentReference_patient_type_period_granular_scope_test
      test from: :us_core_v610_DocumentReference_patient_category_date_granular_scope_test
      test from: :us_core_v610_DocumentReference_patient_category_granular_scope_test
    end
  end
end