require_relative '../search_test'

module USCoreTestKit
  class ScreeningAssessmentCategoryTest < Inferno::Test
    include SearchTest

    id :us_core_screening_assessment_category
    title 'Server demonstrates support for the required Condition and Observation categories.'

    input :patient_ids,
          title: 'Patient IDs',
          description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

    CONDITION_REQUIRED_CATEGORY = 'sdoh'

    # Disable tagging requests since this test doesn't have properties defined.
    # TODO: investigate whether we need to tag these for granular scope
    # checking.
    def tags(_params)
      nil
    end

    def condition_category_found?(patient_id)
      search_params = { patient: patient_id }
      category_search_values = ['health-concern', 'problem-list-item']

      category_search_values.any? do |category_search_value|
        search_params[:category] = category_search_value
        search_and_check_response(search_params, 'Condition')

        resources = fetch_all_bundled_resources(resource_type: 'Condition')
                    .select { |resource| resource.resourceType == 'Condition' }

        resources.any? do |resource|
          resource.category&.any? do |category|
            category.coding&.any? { |coding| CONDITION_REQUIRED_CATEGORY == coding.code }
          end
        end
      end
    end

    def observation_categories_found(patient_id)
      search_params = { patient: patient_id, category: 'survey' }
      search_and_check_response(search_params, 'Observation')

      resources = fetch_all_bundled_resources(resource_type: 'Observation')
                    .select { |resource| resource.resourceType == 'Observation' }

      codes_found =
        resources.flat_map do |resource|
          codes = resource.category&.flat_map do |category|
            category.coding&.map { |coding| coding.code if config.options[:observation_screening_assessment_categories].include?(coding.code) }
          end.compact

          codes
        end

      codes_found.compact.uniq
    end

    run do
      missing_obs_categories = config.options[:observation_screening_assessment_categories].dup
      missing_con_category = true

      patient_id_list.each do |patient_id|
        if missing_con_category
          missing_con_category = !condition_category_found?(patient_id)
        end
        missing_obs_categories -= observation_categories_found(patient_id)
      end

      pass if !missing_con_category && missing_obs_categories.empty?

      message = 'Could not find these '

      if missing_obs_categories.present?
        message += "Observation categories #{missing_obs_categories.join(', ')}"
        message += ' and ' if missing_con_category
      end

      if missing_con_category
         message += "Condition category: #{CONDITION_REQUIRED_CATEGORY}"
      end

      message += '.'

      skip message
    end
  end
end
