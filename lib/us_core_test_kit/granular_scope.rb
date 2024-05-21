module USCoreTestKit
  module GranularScope

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

        first_request = request if request.url != next_page_url

        request_resource_hash[first_request].concat(request_resources)

        next if request.resource&.resourceType != 'Bundle'

        next_page_url = request.resource&.link&.find { |link| link.relation == 'next' }&.url
      end
    end

  end
end