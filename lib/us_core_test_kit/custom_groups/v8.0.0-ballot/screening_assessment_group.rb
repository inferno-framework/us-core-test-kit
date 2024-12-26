require_relative '../screening_assessment_category_test'

module USCoreTestKit
  module USCoreV800_BALLOT
    class ScreeningAssessmentGroup < Inferno::TestGroup
      id :us_core_v800_ballot_screening_assessment
      title 'Screening Assessments Guidance'
      short_description 'Verify Condition and Observation resources support the ' \
                        'US Core Screening And Assessments Guidance.'
      description %(
        The #{title} Sequence tests Condition and Observation
        resources associated with the provided patient. The resources returned
        will be checked for consistency against the [US Core Screening And Assessments
        Guidance](https://hl7.org/fhir/us/core/2025Jan/screening-and-assessments.html)

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
            condition_screening_assessment_categories: [
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
                code: 'sdoh'
              }
            ].freeze,
            observation_screening_assessment_categories: [
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
                code: 'sdoh'
              },
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
                code: 'functional-status'
              },
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
                code: 'disability-status'
              },
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-category',
                code: 'cognitive-status'
              },
              {
                system: 'http://terminology.hl7.org/CodeSystem/observation-category',
                code: 'activity'
              },
              {
                system: 'http://terminology.hl7.org/CodeSystem/observation-category',
                code: 'social-history'
              }
            ].freeze
          }
        )
      end
    end
  end
end
