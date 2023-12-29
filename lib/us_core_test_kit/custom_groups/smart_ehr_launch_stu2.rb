module USCoreTestKit
  class SmartEHRLaunchSTU2 < Inferno::TestGroup
    id :us_core_smart_ehr_launch_stu2
    title 'EHR Launch'

    group from: :smart_discovery_stu2,
          run_as_group: true
    group from: :smart_ehr_launch_stu2,
          run_as_group: true

    group from: :smart_openid_connect do
      run_as_group
      optional
      config(
        inputs: {
          id_token: { name: :ehr_id_token },
          client_id: { name: :ehr_client_id },
          requested_scopes: { name: :ehr_requested_scopes },
          access_token: { name: :ehr_access_token },
          smart_credentials: { name: :ehr_smart_credentials }
        }
      )
    end

    group from: :smart_token_refresh do
      run_as_group
      optional
      config(
        inputs: {
          refresh_token: { name: :ehr_refresh_token },
          client_id: { name: :ehr_client_id },
          client_secret: { name: :ehr_client_secret },
          received_scopes: { name: :ehr_received_scopes }
        }
      )
    end
  end
end
