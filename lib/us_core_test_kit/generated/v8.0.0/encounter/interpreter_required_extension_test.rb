require_relative '../../../interpreter_required_extension_test'

module USCoreTestKit
  module USCoreV800
    class InterpreterRequiredExtensionTest < Inferno::Test
      include USCoreTestKit::InterpreterRequiredExtensionTest

      title 'Certifying server system supports the US Core Interpreter Needed Extension on either the US Core Patient or US Core Encounter Profiles'
      description %(
        Servers can use the US Core Interpreter Needed Extension on the US Core Patient
        or US Core Encounter Profiles to communicate whether a patient needs an interpreter.
        Although the extension is marked as an Additional USCDI Requirements on both US Core
        Patient and US Core Encounter Profiles, the certifying Server system is not required
        to support the extension on both profiles, but SHALL support the extension on at least
        one.
      )

      verifies_requirements 'hl7.fhir.us.core_8.0.0@840', 'hl7.fhir.us.core_8.0.0@852'

      id :us_core_v800_interpreter_required_extension_test

      run do
        verify_interpreter_required_extension_exists
      end
    end
  end
end
