require_relative '../../lib/us_core_test_kit/custom_groups/clinical_note_attachment_test'

RSpec.describe USCoreTestKit::ClinicalNoteAttachmentTest do
  let(:clinical_note_attachment_test) { Inferno::Repositories::Tests.new.find('us_core_clinical_note_attachments') }
  let(:suite_id) { 'us_core_v311' }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { '85' }
  let(:diagnostic_report_id) { '200' }
  let(:test_scratch) {
    {
      document_reference_attachments: {
        patient_id => { "#{url}/Binary/1" => "100" }
      },
      diagnostic_report_attachments: {
        patient_id => { "#{url}/Binary/2" => diagnostic_report_id }
      }
    }
  }

  it 'catches missing attachment' do
    allow_any_instance_of(clinical_note_attachment_test)
      .to receive(:scratch).and_return(test_scratch)

    result = run(clinical_note_attachment_test)
    expect(result.result).to eq('fail')
    expect(result.result_message).to include("#{url}/Binary/2 in DiagnosticReport/#{diagnostic_report_id} for Patient #{patient_id}")
  end
end
