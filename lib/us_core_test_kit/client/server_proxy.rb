# frozen_string_literal: true

module USCoreTestKit
  module Client
    module ServerProxy
      def proxy_client
        @proxy_client ||= Faraday.new(
          url: ENV.fetch('FHIR_REFERENCE_SERVER'),
          params: {},
          headers: request_headers
        ) do |proxy|
          proxy.use FaradayMiddleware::Gzip
          proxy.options.params_encoder = Faraday::FlatParamsEncoder
        end
      end

      def request_headers
        {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer SAMPLE_TOKEN',
        }
      end
    end
  end
end
