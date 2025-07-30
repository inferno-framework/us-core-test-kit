# frozen_string_literal: true

module USCoreTestKit
  module Client
    module TestHelper
      def filter_requests_by_resource_type(requests, resource_type)
        requests.select do |request|
          request.url.split('/').any? { |segment| segment.split('?').first&.casecmp?(resource_type)  }
        end
      end

      def filter_requests_by_resource_id(requests, resource_id)
        Array(resource_id).flat_map do |id|
          requests.select do |request|
            request.url.split('/').last.split('?').first&.casecmp?(id)
          end
        end
      end

      def filter_requests_by_search_parameters(requests, search_parameters)
        requests.select do |request|
          included_params =
            if request.verb.downcase == 'get'
              url_params(request.url).keys
            elsif request.verb.downcase == 'post'
              CGI.parse(request.request_body).keys
            end
          next unless included_params.present?

          search_parameters.all? { |param| included_params.include? param }
        end
      end

      def url_params(url)
        CGI.parse(URI.parse(url).query)
      end
    end
  end
end
