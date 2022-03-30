module USCoreTestKit
  module USCoreV400
    class DocumentReferenceCustodianTest < Inferno::Test
      id :us_core_v400_document_reference_custodian_validation_test
      title 'DocumentReference resources returned during previous tests have custodian'
      description %(
        This test verifies the organization responsible for the DocumentReference is present either in DocumentReference.custodian
        or accessible in the Provenance resource targeting the DocumentReference using Provenance.agent.who or Provenance.agent.onBehalfOf.
      )

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      def scratch_provenance_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        resources = scratch_resources[:all] || []

        skip_if resources.blank?,
                'No DocumentReference resources appeart to be available. ' \
                'Please use patients with more information.'

        scratch_resources[:all].each_with_index do |docref, index|
          has_custodian = docref.custodian.present?

          unless has_custodian
            messages << {
              type: 'error',
              message: "DocumentReference/#{docref.id} does not have DocumentReference.custodian"
            }
          end
        end

        assert !messages.any?, "Resource does not have DocumentReference.custodian"
      end
    end
  end
end