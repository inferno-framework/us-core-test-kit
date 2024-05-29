require_relative '../search_test'

module USCoreTestKit
  class ScreeningAssessmentCategoryTest < Inferno::Test
    include SearchTest

    id :us_core_screening_assessment_category
    title 'Server demonstrates support for the required Condition and Observation categories.'

    input :patient_ids,
          title: 'Patient IDs',
          description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

    CONDITION_REQUIRED_CATEGORY = 'sdoh'.freeze

    # Disable tagging requests since this test doesn't have properties defined.
    # TODO: investigate whether we need to tag these for granular scope
    # checking.
    def tags(_params)
      nil
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def category_found(resource_type:, patient_id:, category_search_values:, missing_categories:)
      search_params = { patient: patient_id }

      category_search_values.each do |category_search_value|
        search_params[:category] = category_search_value
        search_and_check_response(search_params, resource_type)

        resources = fetch_all_bundled_resources(resource_type:)
          .select { |resource| resource.resourceType == resource_type }

        resources.each do |resource|
          resource.category&.each do |category|
            category.coding&.each do |coding|
              missing_categories.delete(coding.code)
            end
          end

          break if missing_categories.empty?
        end

        break if missing_categories.empty?
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    run do
      missing_obs_categories = config.options[:observation_screening_assessment_categories].dup
      missing_cond_categories = config.options[:condition_screening_assessment_categories].dup

      patient_id_list.each do |patient_id|
        unless missing_cond_categories.empty?
          category_found(resource_type: 'Condition',
                         patient_id:,
                         category_search_values: ['health-concern', 'problem-list-item'],
                         missing_categories: missing_cond_categories)
        end

        next if missing_obs_categories.empty?

        category_found(resource_type: 'Observation',
                       patient_id:,
                       category_search_values: ['survey'],
                       missing_categories: missing_obs_categories)
      end

      pass if missing_cond_categories.empty? && missing_obs_categories.empty?

      messages = []
      messages << "Observation categories: #{missing_obs_categories.join(', ')}" unless missing_obs_categories.empty?
      messages << "Condition categories: #{missing_cond_categories.join(', ')}" unless missing_cond_categories.empty?
      skip "Could not find these #{messages.join(' and ')}."
    end
  end
end
