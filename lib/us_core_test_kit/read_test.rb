module USCoreTestKit
  module ReadTest
    def all_scratch_resources
      scratch_resources[:all] ||= []
    end

    def perform_read_test(resources, reply_handler = nil, delayed_reference: false)
      skip_if resources.blank?, no_resources_skip_message

      resources_to_read = if delayed_reference
                            readable_references(resources)
                          else
                            readable_resources(resources)
                          end

      assert resources_to_read.present?, "No #{resource_type} id found."

      if config.options[:read_all_resources]
        if delayed_reference
          all_referencing_resources = referencing_resources(resources_to_read)
          info %(
            The #{resource_type} references used for this test were pulled from the following resources:
            #{all_referencing_resources}
          )
          resources_to_read.map!(&:reference)
        end

        resources_to_read.each do |resource|
          read_and_validate(resource)
        end
      else
        first_resource = resources_to_read.first
        if delayed_reference.present?
          info %(
            The #{resource_type} reference used for this test was pulled from resource
            #{first_resource[:referencing_resource]}
          )
          first_resource = first_resource[:reference]
        end
        read_and_validate(first_resource)
      end
    end

    def referencing_resources(readable_resources)
      readable_resources
        .map { |resource| resource[:referencing_resource] }
        .join(', ')
    end

    def readable_references(resources)
      resources
        .select { |resource| resource[:reference].present? && resource[:reference].is_a?(FHIR::Reference) }
        .select { |resource| resource[:reference].reference.split('/').last.present? }
        .compact
        .uniq { |resource| resource[:reference].reference.split('/').last }
    end

    def readable_resources(resources)
      resources
        .select { |resource| resource.is_a?(resource_class) || resource.is_a?(FHIR::Reference) }
        .select { |resource| (resource.is_a?(FHIR::Reference) ? resource.reference.split('/').last : resource.id).present? }
        .compact
        .uniq { |resource| resource.is_a?(FHIR::Reference) ? resource.reference.split('/').last : resource.id }
    end

    def read_and_validate(resource_to_read)
      id = resource_id(resource_to_read)

      fhir_read resource_type, id

      assert_response_status(200)
      assert_resource_type(resource_type)
      assert resource.id.present? && resource.id == id, bad_resource_id_message(id)

      return unless resource_to_read.is_a? FHIR::Reference

      all_scratch_resources << resource
    end

    def resource_id(resource)
      resource.is_a?(FHIR::Reference) ? resource.reference.split('/').last : resource.id
    end

    def no_resources_skip_message
      "No #{resource_type} resources appear to be available. " \
        'Please use patients with more information.'
    end

    def bad_resource_id_message(expected_id)
      "Expected resource to have id: `#{expected_id.inspect}`, but found `#{resource.id.inspect}`"
    end

    def resource_class
      FHIR.const_get(resource_type)
    end
  end
end
