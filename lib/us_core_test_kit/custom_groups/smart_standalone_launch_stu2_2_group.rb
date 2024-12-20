module USCoreTestKit
  class SmartStandaloneLaunchSTU22 < Inferno::TestGroup
    id :us_core_smart_standalone_launch_stu2_2
    title 'Standalone Launch'

    run_as_group

    group from: :smart_discovery_stu2_2,
          run_as_group: true
    group from: :smart_standalone_launch_stu2_2,
          run_as_group: true

    group from: :smart_openid_connect_stu2_2 do
      run_as_group
      optional
      config(
        inputs: {
          id_token: { name: :standalone_id_token },
          client_id: { name: :standalone_client_id },
          requested_scopes: { name: :standalone_requested_scopes },
          access_token: { name: :standalone_access_token },
          smart_credentials: { name: :standalone_smart_credentials }
        }
      )
    end

    group from: :smart_token_refresh_stu2 do
      run_as_group
      optional
      config(
        inputs: {
          refresh_token: { name: :standalone_refresh_token },
          client_id: { name: :standalone_client_id },
          client_secret: { name: :standalone_client_secret },
          received_scopes: { name: :standalone_received_scopes }
        }
      )
    end
  end
end
