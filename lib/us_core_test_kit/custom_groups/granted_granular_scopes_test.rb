module USCoreTestKit
  class GrantedGranularScopesTest < Inferno::Test
    id :us_core_granted_granular_scopes
    title 'Required granular scopes were granted'

    description %()

    input :received_scopes

    run do
      required_granular_scopes =
        config
          .options[:required_scopes]
          .map { |scope| scope[scope.index('/') + 1, scope.length] }

      received_granular_scopes =
        received_scopes
          .split(' ')
          .select { |scope| scope.include? '?' }
          .map { |scope| scope[scope.index('/') + 1, scope.length] }

      missing_scopes = required_granular_scopes - received_granular_scopes

      wrapped_missing_scopes = missing_scopes.map { |scope| "`#{scope}`" }

      assert missing_scopes.empty?,
             "The following granular scopes were not granted: #{wrapped_missing_scopes.to_sentence}"

      granular_scope_resource_types =
        required_granular_scopes
          .map { |scope| scope.split('.').first }
          .uniq

      received_resource_level_scopes =
        received_scopes
          .split(' ')
          .reject { |scope| scope.include? '?' }
          .select { |scope| scope.match? %r{\A(user|patient|system|\*)/.+\..+} }
          .map { |scope| scope[scope.index('/') + 1, scope.length] }
          .select { |scope| granular_scope_resource_types.include? scope[0, scope.index('.')] }

      wrapped_resource_scopes = received_resource_level_scopes.map { |scope| "`#{scope}`" }

      assert received_resource_level_scopes.empty?,
             'Can not verify the behavior of granular scopes because the following resource-level scopes were ' \
             "granted: #{wrapped_resource_scopes.to_sentence}"

      received_wildcard_scopes =
        received_scopes
          .split(' ')
          .select { |scope| scope.match? %r{\A(user|patient|system|\*)/\*} }

      wrapped_wildcard_scopes = received_wildcard_scopes.map { |scope| "`#{scope}`" }

      assert received_wildcard_scopes.empty?,
             'Can not verify the behavior of granular scopes because the following wildcard scopes were ' \
             "granted: #{wrapped_wildcard_scopes.to_sentence}"

    end
  end
end
