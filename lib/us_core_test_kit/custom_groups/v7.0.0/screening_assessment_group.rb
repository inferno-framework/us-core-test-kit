require_relative '../screening_assessment_category_test'

module USCoreTestKit
  module USCoreV700
    class ScreeningAssessmentGroup < Inferno::TestGroup
      id :us_core_v700_screening_assessment
      title 'Screening Assessments Guidance'
      short_description 'Verify Condition and Observation resources support the ' \
                        'US Core Screening And Assessments Guidance.'
      description %(
        The #{title} Sequence tests Condition and Observation
        resources associated with the provided patient. The resources returned
        will be checked for consistency against the [US Core Screening And Assessments
        Guidance](https://hl7.org/fhir/us/core/STU7/screening-and-assessments.html)
        and FHIR JIRA ticket [FHIR-46052](https://jira.hl7.org/browse/FHIR-46052)

        In this set of tests, Inferno serves as a FHIR client that attempts to
        access the different types of Screening and Assessments specified in the guidance.
        The provided patient needs to have the following four common Screening and Assessements
        as Observation categories:

        * SDOH Assessment (sdoh)
        * Functional Status (functional-status)
        * Disability Status (disability-status)
        * Mental/Cognitive Status (cognitive-status)
        * Physical Activity (activity)
        * Alcohol Use (social-history)
        * Substance Use (social-history)

        The provided patient also needs to have the following common Screening and Assessment
        as Condition category:

        * SDOH Assessment (sdoh)
      )
      run_as_group

      test from: :us_core_screening_assessment_category do
        config(
          options: {
            condition_screening_assessment_categories: ['sdoh'].freeze,
            observation_screening_assessment_categories: ['sdoh', 'functional-status', 'disability-status',
                                                          'cognitive-status', 'activity', 'social-history'].freeze
          }
        )
      end
    end
  end
end
