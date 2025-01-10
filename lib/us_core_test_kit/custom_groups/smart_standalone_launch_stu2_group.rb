require_relative 'smart_scopes_constants'

module USCoreTestKit
  class SmartStandaloneLaunchSTU2 < Inferno::TestGroup
    include SmartScopesConstants

    id :us_core_smart_standalone_launch_stu2
    title 'Standalone Launch'

    run_as_group

    config(
      inputs: {
        smart_auth_info: {
          name: :smart_auth_info,
          options: {
            components: [
              {
                name: :requested_scopes,
                default: SMART_V2_RESOURCE_LEVEL_SCOPES
              }
            ]
          }
        },
        received_scopes: { name: :standalone_received_scopes }
      },
      outputs: {
        smart_auth_info: {
          name: :smart_auth_info
        }
      }
    )

    group from: :smart_discovery_stu2,
          run_as_group: true
    group from: :smart_standalone_launch_stu2,
          run_as_group: true

    group from: :smart_openid_connect do
      run_as_group
      optional
      config(
        inputs: {
          id_token: { name: :standalone_id_token }
        }
      )
    end

    group from: :smart_token_refresh do
      run_as_group
      optional
    end
  end
end
