require 'pry'
require 'pry-byebug'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError # rubocop:disable Lint/SuppressedException
end

namespace :db do
  desc 'Apply changes to the database'
  task :migrate do
    require 'inferno'

    Inferno::Application.start(:db)
  end
end

namespace :us_core do
  desc 'Generate tests'
  task :generate do
    require_relative 'lib/us_core/generator'
    generator = USCore::Generator.new

    x = generator.load_ig_package

    binding.pry
  end
end
