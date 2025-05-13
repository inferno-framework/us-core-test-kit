module USCoreTestKit
  module Client
    module MetadataHelper
      module_function

      def get_metadata(version)
        erb_template = ERB.new(
          File.read(
            File.join(__dir__,
                      "generated/#{version}/metadata/mock_capability_statement.json.erb")
          )
        )
        capability_statement = JSON.parse(erb_template.result).to_json

        proc {
          [200, { 'Content-Type' => 'application/fhir+json;charset=utf-8' },
          [capability_statement]]
        }
      end
    end
  end
end