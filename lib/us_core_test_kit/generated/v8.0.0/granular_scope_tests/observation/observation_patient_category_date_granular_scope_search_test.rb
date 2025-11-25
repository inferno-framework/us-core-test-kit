require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_search_test'

module USCoreTestKit
  module USCoreV800
    class ObservationPatientCategoryDateGranularScopeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeSearchTest

      title 'Server filters results for Observation search by patient + category + date based on granular scopes'
      description %(
This test repeats all Observation searches by
patient + category + date and verifies that the results have been
filtered based on the granted granular scopes. The response to each
repeated request will be compared to the corresponding original response
independently using the following logic:
- If the repeated search filters on a category value that
  is explicitly included within the granted scopes, e.g., a search for
  `Observation?category=survey` when the granted scopes includes
  `patient/Observation.rs?category=survey`, then the server is required to
  return the original response filtered to include only entries that match
  one of the granted scopes.
- Otherwise, e.g., a search for `Observation?category=cognitive-status`
  when the granted scopes include only `patient/Observation.rs?category=survey`,
  servers may indicate that the request is unauthorized either through an empty
  Bundle or an explicit HTTP error, or they may return the original response
  filtered to include only entries that match one of the granted scopes.

      )

      id :us_core_v800_Observation_patient_category_date_granular_scope_search_test
      optional

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
        search_param_names: ['patient', 'category', 'date']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        run_scope_search_test
      end
    end
  end
end
