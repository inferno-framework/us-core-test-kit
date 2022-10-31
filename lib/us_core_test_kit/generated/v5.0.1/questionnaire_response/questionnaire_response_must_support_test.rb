require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV501
    class QuestionnaireResponseMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the QuestionnaireResponse resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the QuestionnaireResponse resources
        found previously for the following must support elements:

        * QuestionnaireResponse.author
        * QuestionnaireResponse.authored
        * QuestionnaireResponse.identifier
        * QuestionnaireResponse.item
        * QuestionnaireResponse.item.answer
        * QuestionnaireResponse.item.answer.item
        * QuestionnaireResponse.item.answer.valueCoding
        * QuestionnaireResponse.item.answer.valueDecimal
        * QuestionnaireResponse.item.answer.valueString
        * QuestionnaireResponse.item.item
        * QuestionnaireResponse.item.linkId
        * QuestionnaireResponse.item.text
        * QuestionnaireResponse.meta
        * QuestionnaireResponse.meta.tag
        * QuestionnaireResponse.meta.tag:sdoh
        * QuestionnaireResponse.questionnaire
        * QuestionnaireResponse.questionnaire.extension:questionnaireDisplay
        * QuestionnaireResponse.questionnaire.extension:url
        * QuestionnaireResponse.status
        * QuestionnaireResponse.subject
      )

      id :us_core_v501_questionnaire_response_must_support_test

      def resource_type
        'QuestionnaireResponse'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:questionnaire_response_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
