module USCoreTestKit
  class ClinicalNotesWriteWorkflowAttestationTest < Inferno::Test
    id :us_core_v900_clinical_notes_write_workflow_attestation
    title 'Server supports the US Core Clinical Notes write workflows'
    description %(
      This attestation covers the Clinical Notes write workflows added in US Core v9:
      PATAST create requests; content.format acceptance and round-trip; inline attachments
      up to 5 MiB without exposing client-supplied URLs; author and encounter references;
      partial PUT to entered-in-error; relatesTo replaces round-trip; and required client
      create fields.
    )

    input :clinical_notes_write_workflows_supported,
          title: 'Clinical Notes write workflows supported',
          description: 'Enter yes after verifying that all described Clinical Notes write workflows are supported.'

    run do
      assert clinical_notes_write_workflows_supported.to_s.casecmp('yes').zero?,
             'Enter yes after verifying the Clinical Notes write workflows.'
    end
  end
end
