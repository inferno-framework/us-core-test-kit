# coding: utf-8
require_relative '../../search_test'

module USCoreTestKit
  module USCoreV400
    class ClinicalNotesGuidanceGroup < Inferno::TestGroup
      id :us_core_400_clinical_notes_guidance
      title 'Clinical Notes Guidance'
      short_description 'Verify DiagnosticReport and DocumentReference resources support the US Core Clinical Notes Guidance.'
      description %(
        The #{title} Sequence tests DiagnosticReport and DocumentReference
        resources associated with the provided patient. The resources returned
        will be checked for consistency against the [US Core Clinical Notes
        Guidance](https://www.hl7.org/fhir/us/core/clinical-notes-guidance.html)

        In this set of tests, Inferno serves as a FHIR client that attempts to
        access the different types of Clinical Notes specified in the guidance.
        The provided patient needs to have the following five common clinical
        notes as DocumentReference resources:

        * Consultation Note (11488-4)
        * Discharge Summary (18842-5)
        * History & Physical Note (34117-2)
        * Procedures Note (28570-0)
        * Progress Note (11506-3)
        * Imaging Narrative (18748-4)
        * Laboratory Report Narrative (11502-2)
        * Pathology Report Narrative (11526-1)

        The provided patient also needs to have the following three common
        diagnostic reports as DiagnosticReport resources:

        * Cardiology (LP29708-2)
        * Pathology (LP7839-6)
        * Radiology (LP29684-5)

        In order to enable consistent access to scanned narrative-only clinical
        reports, the US Core server shall expose these reports through both
        DiagnosticReport and DocumentReference by representing the same attachment
        url.
      )
      run_as_group

      test do
        include SearchTest

        id :us_core_311_clinical_note_types
        title 'Server demonstrates support for the required DocumentReference types and DiagnosticReport categories.'
        description %(
          [The US Core Clinical Notes
          Guidance](https://hl7.org/fhir/us/core/STU4/clinical-notes-guidance.html)
          states that systems SHALL support the following five "Common Clinical
          Notes":

          * Consultation Note (11488-4)
          * Discharge Summary (18842-5)
          * History & Physical Note (34117-2)
          * Procedures Note (28570-0)
          * Progress Note (11506-3)
          * Imaging Narrative (18748-4)
          * Laboratory Report Narrative (11502-2)
          * Pathology Report Narrative (11526-1)

          and three DiagnosticReport categories:

          * Cardiology (LP29708-2)
          * Pathology (LP7839-6)
          * Radiology (LP29684-5)
        )
        input :patient_ids,
              title: 'Patient IDs',
              description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

        REQUIRED_TYPES = ['11488-4', '18842-5', '34117-2', '28570-0', '11506-3', '18748-4', '11502-2', '11526-1'].freeze
        REQUIRED_CATEGORIES = ['LP29708-2', 'LP7839-6', 'LP29684-5'].freeze

        def document_reference_types_found(patient_id)
          search_params = { patient: patient_id }
          status_values = ['current,superseded,entered-in-error']

          search_and_check_response(search_params, 'DocumentReference')

          if response[:status] == 400
            perform_search_with_status(
              params,
              patient_id,
              status_search_values: status_values,
              resource_type: 'DocumentReference'
            )
          end

          resources = fetch_all_bundled_resources(resource_type: 'DocumentReference')
                        .select { |resource| resource.resourceType == 'DocumentReference' }

          scratch[:document_reference_attachments] ||= {}
          scratch[:document_reference_attachments][patient_id] ||= {}
          attachments = scratch[:document_reference_attachments][patient_id]

          codes_found =
            resources.flat_map do |resource|
              resource.content
                &.select { |content| !attachments.key? content.attachment&.url}
                &.each { |content| attachments[content.attachment.url] = resource.id }

              resource.type&.coding&.map { |coding| coding.code }
            end

          codes_found.compact.uniq
        end

        def diagnostic_report_categories_found(patient_id)
          search_params = { patient: patient_id }
          status_values = ['registered,partial,preliminary,final,amended,corrected,appended,cancelled,entered-in-error,unknown']

          search_and_check_response(search_params, 'DiagnosticReport')

          if response[:status] == 400
            perform_search_with_status(
              params,
              patient_id,
              status_search_values: status_values,
              resource_type: 'DiagnosticReport'
            )
          end

          resources = fetch_all_bundled_resources(resource_type: 'DiagnosticReport')
                        .select { |resource| resource.resourceType == 'DiagnosticReport' }

          scratch[:diagnostic_report_attachments] ||= {}
          scratch[:diagnostic_report_attachments][patient_id] ||= {}
          attachments = scratch[:diagnostic_report_attachments][patient_id]

          codes_found =
            resources.flat_map do |resource|
              resource.presentedForm
                &.select { |attachment| !attachments.key? attachment&.url}
                &.each { |attachment| attachments[attachment.url] = resource.id }

              resource.category&.flat_map { |category| category.coding&.map { |coding| coding.code } }
            end

          codes_found.compact.uniq
        end

        run do
          require 'pry'; require 'pry-byebug'; binding.pry
          missing_types = REQUIRED_TYPES.dup
          missing_categories = REQUIRED_CATEGORIES.dup

          patient_id_list.each do |patient_id|
            missing_types -= document_reference_types_found(patient_id)
            missing_categories -= diagnostic_report_categories_found(patient_id)
          end

          pass if missing_types.empty? && missing_categories.empty?

          message = 'Could not find these '

          if missing_types.present?
            message += "DocumentReference types: #{missing_types.join(', ')}"
            message += ' and ' if missing_categories.present?
          end

          if missing_categories.present?
            message += "DiagnosticReport categories #{missing_categories.join(', ')}."
          end

          skip message
        end
      end

      test do
        id :us_core_311_clinical_note_attachments
        title 'DiagnosticReport and DocumentReference reference the same attachment'
        description %(
          All presentedForms urls referenced in DiagnosticReports shall have
          corresponding content attachment urls referenced in DocumentReference.

          There is no single best practice for representing a scanned, or
          narrative-only report due to the overlapping scope of the underlying
          resources and variability in system implementation. Reports may be
          represented by either a DocumentReference or a DiagnosticReport. To
          require Clients query both DocumentReference and DiagnosticReport to get
          all the information for a patient is potentially dangerous if a client
          doesn’t understand or follow this requirement.

          To simplify the requirement, US Core IG requires servers implement the
          duplicate reference to allow a client to find a Pathology report, or
          other Diagnostic Reports, in either Resource.
        )

        run do
          skip_if scratch[:document_reference_attachments].blank?,
                  "No DocumentReference attachments found"
          skip_if scratch[:diagnostic_report_attachments].blank?,
                  "No DiagnosticReport attachments found"

          unmatched_attachment_messages =
            scratch[:diagnostic_report_attachments].flat_map do |patient_id, report_attachments|
              unmatched_urls = report_attachments.keys

              if scratch[:document_reference_attachments].key? patient_id
                unmatched_urls -= scratch[:document_reference_attachments][patient_id].keys
              end

              unmatched_urls.map do |url|
                "#{url} in DiagnosticReport/#{report_attachments[patient_id][url]} for Patient #{patient_id}"
              end
            end

          assert unmatched_attachment_messages.empty?,
                "Attachments #{unmatched_attachment_messages.join(', ')} are not referenced in any DocumentReference"
        end
      end
    end
  end
end
