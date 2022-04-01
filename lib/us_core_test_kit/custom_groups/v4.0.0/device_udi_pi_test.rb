module USCoreTestKit
  module USCoreV400
    class DeviceUdiPiTest < Inferno::Test
      id :us_core_v400_device_udi_pi_test
      title 'Device resources returned during previous tests have UDI-PI elements'
      description %(
        This test verifies implantable medical devices that have UDI information represent all of the UDI-PI elements that are present in the UDI code
        in the corresponding US Core Implantable Device Profile element.
      )

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        resources = scratch_resources[:all] || []

        skip_if resources.blank?,
                'No Devices resources appeart to be available. ' \
                'Please use patients with more information.'

        resources.each do |device|
          if device.udiCarrier&.first&.carrierHRF.present? &&
            !(
              device.manufactureDate.present? ||
              device.expirationDate.present? ||
              device.lotNumber.present? ||
              device.serialNumber.present? ||
              device.distinctIdentifier.present?
            )
            add_message('error',
                        "Device/#{device.id} has UDI information but does not have any UDI-PI elements presented")
          end
        end

        assert messages.blank?, "Resource has UDI information but does not have any UDI-PI elements presented"
      end
    end
  end
end