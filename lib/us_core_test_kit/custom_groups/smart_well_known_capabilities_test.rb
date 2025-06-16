module USCoreTestKit
  class SmartWellKnownCapabilitiesTest < Inferno::Test
    title 'Well-known configuration declares support for Additional US Core Required capabilities'
    description %(
      US Core requires following additional metadata:
      * scopes_supported: Array of scopes a client may request.
        * The server SHALL support all scopes listed in the table above for the US Core Profiles they support;
        additional scopes MAY be supported.
      * introspection_endpoint: The URL to a server’s introspection endpoint, which can be used to validate a token.
        * Servers SHALL document this endpoint in the file

      [Additional US Core Requirements](https://hl7.org/fhir/us/core/scopes.html#additional-us-core-requirements)
    )
    id :us_core_smart_well_known_capabilities
    input :well_known_configuration

    verifies_requirements 'hl7.fhir.us.core_7.0.0@167',
                          'hl7.fhir.us.core_7.0.0@168',
                          'hl7.fhir.us.core_7.0.0@173'

    run do
      skip_if well_known_configuration.blank?, 'No well-known SMART configuration found.'

      assert_valid_json(well_known_configuration)
      config = JSON.parse(well_known_configuration)

      scopes_supported = config['scopes_supported']
      assert scopes_supported.present?, 'Well-known configuration does not include `scopes_supported`'
      assert scopes_supported.is_a?(Array),
             "Well-known `scopes_supported` must be type of Array, but found #{scopes_supported.class.name}"

      pattern = %r{^(patient|user|system|\*)/([a-zA-Z*]+)\.([cruds]+)(\?\w+=[^\s&]+(&\w+=[^\s&]+)*)?$}
      has_fhir_resource_scopes = scopes_supported.any? { |scope| scope.match?(pattern) }
      assert has_fhir_resource_scopes,
             'Well-known `scopes_supported` does not have any FHIR Resource scopes: ' \
             '<patient|user|system>/<fhir-resource>.<c|r|u|d|s>[?param=value]'

      introspection_endpoint = config['introspection_endpoint']
      assert introspection_endpoint.present?, 'Well-known configuration does not include `introspection_endpoint`'
      assert introspection_endpoint.is_a?(String),
             "Well-known `introspection_endpoint` must be type of Array, but found #{introspection_endpoint.class.name}"
    end
  end
end
