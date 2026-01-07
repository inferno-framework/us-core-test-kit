module USCoreTestKit
  module GranularScope
    require 'uri'

    def granular_scopes
      @granular_scopes ||=
        received_scopes
          .split(' ')
          .select do |scope|
            (scope.start_with?("patient/#{resource_type}") || scope.start_with?("user/#{resource_type}")) &&
              scope.include?('?')
          end
    end

    def granular_scope_search_params
      @granular_scope_search_params ||=
        granular_scopes.map do |scope|
          _, granular_scope = scope.split('?')
          name, value = granular_scope.split('=')

          {
            name:,
            value:
          }
        end
    end

    def resource_specific_granular_scope_search_params
      @resource_specific_granular_scope_search_params ||=
        granular_scopes.select {|scope| scope.include?(resource_type)}.map do |scope|
          _, granular_scope = scope.split('?')
          name, value = granular_scope.split('=')
          _, value = value.split('|')
          {
            name:,
            value:
          }
      end
    end

    def resolve_url(url, base_url)
      return nil if url.nil?
      
      uri = URI.parse(url)
      # If already absolute, return as-is
      return url if uri.absolute?
      
      # If relative, resolve against base URL
      base_uri = URI.parse(base_url)
      resolved = URI.join("#{base_uri.scheme}://#{base_uri.host}#{":#{base_uri.port}" if base_uri.port && ![80, 443].include?(base_uri.port)}", url)
      resolved.to_s
    rescue URI::InvalidURIError
      url
    end

    def previous_request_resources
      first_request = previous_requests.first
      next_page_url = nil
      base_url = nil
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_requests.each_with_object(hash) do |request, request_resource_hash|
        # Extract base URL from first request for resolving relative URLs
        base_url ||= request.url
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource).select { |resource| resource.resourceType == resource_type }
          else
            []
          end

        # Resolve relative URLs to absolute for accurate comparison
        resolved_next_page_url = resolve_url(next_page_url, base_url)
        first_request = request if request.url != resolved_next_page_url

        request_resource_hash[first_request].concat(request_resources)

        next if request.resource&.resourceType != 'Bundle'

        next_page_url = request.resource&.link&.find { |link| link.relation == 'next' }&.url
      end
    end

  end
end