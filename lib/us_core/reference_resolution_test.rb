require_relative '../us_core/generated/resource_list'

module USCore
  module ReferenceResolutionTest
    include ResourceList

    def perform_reference_resolution_test(resources)
      skip_if resources.blank?, no_resources_skip_message

      self.resolution_count = 0

      resources.each do |resource|
        break if resolution_count >= max_resolutions

        validate_reference_resolutions(resource)
      end

      messages.uniq!
      errors_found = messages.any? { |message| message[:type] == 'error' }

      assert !errors_found, "Inferno was unable to resolve all US Core references"
    end

    def max_resolutions
      50
    end

    def resolution_count
      @resolution_count
    end

    def resolution_count=(count)
      @resolution_count = count
    end

    def record_resolved_reference(reference)
      self.resolution_count += 1
      resolved_references.add?(reference.reference)
    end

    def resolved_references
      scratch[:resolved_references] ||= Set.new
    end

    def no_resources_skip_message
      "No #{resource_type} resources appeart to be available. " \
      'Please use patients with more information.'
    end

    def validate_reference_resolutions(resource)
      problems = []

      resource.each_element do |reference, meta, path|
        next if meta['type'] != 'Reference'
        next if reference.reference.blank?
        next if resolved_references.include?(reference.reference)
        break if resolution_count >= max_resolutions

        if reference.contained?
          # if reference_id is blank it is referring to itself, so we know it exists
          next if reference.reference_id.blank?

          unless resource.contained.any? { |contained_resource| contained_resource&.id == reference.reference_id }
            messages << {
              type: 'error',
              message: "#{path} has contained reference to id '#{reference.reference_id}' that does not exist"
            }
          end

          next
        end

        # Should potentially update valid? method in fhir_dstu2_models
        # to check for this type of thing
        # e.g. "patient/54520" is invalid (fhir_client resource_class method would expect "Patient/54520")
        if reference.relative?
          begin
            reference.resource_class
          rescue NameError
            problems << "#{path} has invalid resource type in reference: #{reference.type}"
            next
          end
        end
        reference_type = reference.resource_type

        begin
          resolved_resource = reference.read
        rescue ClientException => e
          # report error if the resource is a US Core resource type
          messages << {
            type: 'error',
            message: "#{path} did not resolve: #{e}"
          } if RESOURCE_LIST.include?(reference_type)

          next
        end

        if resolved_resource&.resourceType == reference_type
          record_resolved_reference(reference)
        else
          messages << {
            type: 'error',
            message: "Expected #{reference.reference} to refer to a #{reference_type} resource, " \
                     "but found a #{resolved_resource&.resourceType} resource."
          }
        end
      end
    end
  end
end
