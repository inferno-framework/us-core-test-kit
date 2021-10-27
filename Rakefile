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

    generator.generate
  end

  desc 'Check metadata'
  task :check_metadata do
    require 'YAML'

    expected_metadata = YAML.load_file('expected_metadata.yml')
    metadata = YAML.load_file('metadata.yml')

    if metadata == expected_metadata
      puts 'Metadata matches!'
    else
      # Metadata does not match
      binding.pry
    end
  end
end
