module USCore
  module ReadTest
    def perform_read_test(resources, reply_handler = nil)
      skip_if resources.blank?, no_resources_skip_message

      resource_given = resources.find do |resource|
        resource.is_a?(resource_class) || resource.is_a?(FHIR::Reference)
      end

      id =
        if resource_given.is_a? FHIR::Reference
          resource_given.reference.split('/').last
        else
          resource_given&.id
        end

      assert id.present?, "No #{resource_type} id found."

      fhir_read resource_type, id

      assert_response_status(200)
      # TODO: DAR checks
      # reply_handler&.call(resource)

      assert_resource_type(resource_type)
      assert resource.id.present? && resource.id == id, bad_resource_id_message(id)
    end

    def no_resources_skip_message
      "No #{resource_type} resources appeart to be available. " \
      'Please use patients with more information.'
    end

    def bad_resource_id_message(expected_id)
      "Expected resource to have id: `#{id}`, but found `#{resource.id}`"
    end

    def resource_class
      FHIR.const_get(resource_type)
    end
  end
end
