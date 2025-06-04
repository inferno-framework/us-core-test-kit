require_relative 'lib/us_core_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'us_core_test_kit'
  spec.version       = USCoreTestKit::VERSION
  spec.authors       = ['Stephen MacVicar']
  spec.email         = ['inferno@groups.mitre.org']
  spec.summary       = 'US Core Inferno tests'
  spec.description   = 'US Core Inferno tests'
  spec.homepage      = 'https://github.com/inferno-framework/us-core-test-kit'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '>= 0.6.8'
  spec.add_runtime_dependency 'smart_app_launch_test_kit', '>= 0.6.3'
  spec.add_runtime_dependency 'tls_test_kit', '~> 0.3.0'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  spec.metadata['inferno_test_kit'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/inferno-framework/us-core-test-kit'
  spec.files         = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")

  spec.require_paths = ['lib']
end
