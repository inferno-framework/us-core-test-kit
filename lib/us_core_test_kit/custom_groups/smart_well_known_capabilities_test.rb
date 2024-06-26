module USCoreTestKit
  class SMARTWellKnownCapabilitiesTest < Inferno::Test

    title 'Well-known configuration declares support for required capabilities'
    description %(
      A SMART on FHIR server SHALL convey its capabilities to app developers
      by listing the SMART core capabilities supported by their
      implementation within the Well-known configuration file. This test
      ensures that the capabilities required by this scenario are properly
      documented in the Well-known file.
    )
    id :us_core_smart_well_known_capabilities
    input :well_known_configuration

    run do
      skip_if well_known_configuration.blank?, 'No well-known SMART configuration found.'

      assert_valid_json(well_known_configuration)
      config = JSON.parse(well_known_configuration)

      scopes_supported = config['scopes_supported']
      assert scopes_supported.present?, "Well-known configuration does not include `scopes_supported`"
      assert scopes_supported.is_a?(Array), "Well-known `scopes_supported` must be type of Array, but found #{scopes_supported.class.name}"
      # Add regex check of scopes pattern

      introspection_endpoint = config['introspection_endpoint']
      assert introspection_endpoint.present?, "Well-known configuration does not include `introspection_endpoint`"
      assert introspection_endpoint.is_a?(Array), "Well-known `introspection_endpoint` must be type of Array, but found #{introspection_endpoint.class.name}"
    end
  end
end
