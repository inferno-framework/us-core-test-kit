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

    def resolve_url(url_string)
      return nil if url_string.nil?
      
      uri = URI.parse(url_string)
      # If already absolute, return as-is
      return url_string if uri.absolute?
      
      # If relative, resolve against the configured FHIR base URL
      # Per FHIR spec, relative URLs are interpreted relative to the FHIR base URL
      # Strip leading slash from relative URL if present to prevent URI.join from
      # treating it as absolute path from root, and ensure base has trailing slash
      base_with_slash = url.end_with?('/') ? url : "#{url}/"
      relative_without_leading_slash = url_string.start_with?('/') ? url_string[1..-1] : url_string
      resolved = URI.join(base_with_slash, relative_without_leading_slash)
      resolved.to_s
    rescue URI::InvalidURIError
      url_string
    end

    def previous_request_resources
      first_request = previous_requests.first
      next_page_url = nil
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_requests.each_with_object(hash) do |request, request_resource_hash|
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource).select { |resource| resource.resourceType == resource_type }
          else
            []
          end

        # Check if current request URL matches the next page URL from the previous request
        # If not, this is a new search, so update first_request
        resolved_next_page_url = resolve_url(next_page_url)
        first_request = request if request.url != resolved_next_page_url

        request_resource_hash[first_request].concat(request_resources)

        # Extract the next page URL from the current request's bundle for the next iteration
        next if request.resource&.resourceType != 'Bundle'

        next_page_url = request.resource&.link&.find { |link| link.relation == 'next' }&.url
      end
    end

  end
end