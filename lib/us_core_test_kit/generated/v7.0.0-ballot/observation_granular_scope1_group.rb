require_relative 'observation_lab/observation_patient_category_granular_scope_test'
require_relative 'observation_lab/observation_patient_category_date_granular_scope_test'
require_relative 'observation_lab/observation_patient_code_granular_scope_test'
require_relative 'observation_lab/observation_patient_category_status_granular_scope_test'
require_relative 'observation_lab/observation_patient_code_date_granular_scope_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ObservationGranularScope1Group < Inferno::TestGroup
      title 'Observation Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core Laboratory Result Observation Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`
* `Observation.rs?category=http://terminology.hl7.org//CodeSystem-observation-category.html|social-history`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|imagin`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|procedure`

      )

      id :us_core_v700_ballot_observation_granular_scope_1_group
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'observation_lab', 'metadata.yml'), aliases: true))
      end
    
      test from: :us_core_v700_ballot_Observation_patient_category_granular_scope_test
      test from: :us_core_v700_ballot_Observation_patient_category_date_granular_scope_test
      test from: :us_core_v700_ballot_Observation_patient_code_granular_scope_test
      test from: :us_core_v700_ballot_Observation_patient_category_status_granular_scope_test
      test from: :us_core_v700_ballot_Observation_patient_code_date_granular_scope_test
    end
  end
end
