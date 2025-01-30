# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# - Update for your local path to inferno_core.
# - In inferno_core, checkout the `auth-info-fixes` branch
# - In inferno_core, run `npm run build`
# - bundle install in this repo
gem 'inferno_core',
    path: '../inferno'
gem 'smart_app_launch_test_kit',
    git: 'https://github.com/inferno-framework/smart-app-launch-test-kit.git',
    branch: 'fi-3093-use-auth-info'

group :development, :test do
  gem 'debug'
  gem 'rack-test'
end
