# frozen_string_literal: true

require 'uri'
require_relative '../../test_helper'

module USCoreTestKit
  module Client
    module USCoreClientV900
      module TestHelper
        include USCoreTestKit::Client::TestHelper

        def filter_requests_by_resource_id(requests, resource_id)
          Array(resource_id).flat_map do |id|
            requests.select do |request|
              URI.parse(request.url).path.split('/').last == id
            end
          end
        end
      end
    end
  end
end
