# frozen_string_literal: true

require_relative '../../metadata_helper'

module USCoreTestKit
  module Client
    module USCoreClientV900
      module MetadataHelper
        module_function

        def get_metadata
          response = USCoreTestKit::Client::MetadataHelper.get_metadata('v900').call
          capability_statement = JSON.parse(response[2].join)
          capability_statement['rest'].first['resource'] = JSON.parse(
            File.read(File.join(__dir__, '../../fixtures/v9.0.0/capability_resources.json'))
          )
          capability_statement['instantiates'] = ['http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|9.0.0']
          capability_statement['implementationGuide'] = ['http://hl7.org/fhir/us/core/ImplementationGuide/hl7.fhir.us.core|9.0.0']

          proc { [response[0], response[1], [capability_statement.to_json]] }
        end
      end
    end
  end
end
