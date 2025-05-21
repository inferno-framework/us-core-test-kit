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

      def build_proxied_read_response
        resource_id = request.params[:resource_id]
        resource_type = request.params[:resource_type]
        request_params = request.params.to_h.except(:resource_id, :resource_type).stringify_keys
        
        server_response = proxy_client.get("#{resource_type}/#{resource_id}", request_params)
        response.status = server_response.status
        response.body = server_response.body
        response.headers.merge!(server_response.headers)
        remove_transfer_encoding_and_content_length_header(response.headers)
        response.headers.delete('content-location') if response.headers['content-location'].present?
      end

      def build_proxied_search_response
        resource_type = request.params[:resource_type]
        request_params = request.params.to_h.except(:resource_type).stringify_keys
        
        server_response = proxy_client.get(resource_type, request_params)
        response.status = server_response.status
        response.body = if response.status == 200
                          replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
                        else
                          server_response.body
                        end
        response.headers.merge!(server_response.headers)
        remove_transfer_encoding_and_content_length_header(response.headers)
      end

      def remove_transfer_encoding_and_content_length_header(headers)
        headers.delete('transfer-encoding') if headers['transfer-encoding'].present?
        headers.delete('Content-Length') if headers['Content-Length'].present?

        nil
      end

      def replace_bundle_urls(bundle)
        reference_server_base = ENV.fetch('FHIR_REFERENCE_SERVER')
        bundle&.link&.map! { |link| { relation: link.relation, url: link.url.gsub(reference_server_base, new_link) } }
        bundle&.entry&.map! do |bundled_resource|
          { fullUrl: bundled_resource.fullUrl.gsub(reference_server_base, new_link),
            resource: bundled_resource.resource,
            search: bundled_resource.search }
        end
        bundle
      end

      def new_link
        "#{Inferno::Application['base_url']}/custom/#{suite_id}/fhir"
      end
    end
  end
end
