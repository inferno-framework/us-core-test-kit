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
        requests.select do |request|
          request.url.split('/').last.split('?').first&.casecmp?(resource_id)
        end
      end

      def filter_requests_by_search_parameters(requests, search_parameters)
        requests.select do |request|
          included_params = url_params(request.url).keys
          search_parameters.all? { |param| included_params.include? param }
        end
      end

      def url_params(url)
        CGI.parse(URI.parse(url).query)
      end
    end
  end
end
