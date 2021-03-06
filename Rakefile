#!/usr/bin/env rake

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    require 'rubocop/rake_task'
    desc 'run ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'foodcritic'
    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any']
      }
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    require 'kitchen'
    desc 'run test kitchen with vagrant'
    task :vagrant do
      Kitchen.logger = Kitchen.default_file_logger
      Kitchen::Config.new.instances.each do |instance|
        instance.test(:always)
      end
    end

    desc 'run test kitchen with cloud plugins'
    task :cloud do
      run_kitchen = true
      if ENV['TRAVIS'] == 'true' && ENV['TRAVIS_PULL_REQUEST'] != 'false'
        run_kitchen = false
      end

      if run_kitchen
        Kitchen.logger = Kitchen.default_file_logger
        @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        config.instances.each do |instance|
          instance.test(:always)
        end
      end
    end
  rescue LoadError
    puts '>>>>> kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# TODO: Unit tests with rspec/chefspec
# namespace :unit do
#   begin
#     require 'rspec/core/rake_task'
#     desc 'Run unit tests with RSpec/ChefSpec'
#     RSpec::Core::RakeTask.new(:rspec) do |t|
#       t.rspec_opts = [].tap do |a|
#         a.push('--color')
#         a.push('--format progress')
#       end.join(' ')
#     end
#   rescue LoadError
#     puts '>>>>> rspec gem not loaded, omitting tasks' unless ENV['CI']
#   end
# end
#
# task unit: ['unit:rspec']

desc 'run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'run all tests on cloud provider'
task cloud: ['style', 'integration:cloud']

desc 'run all tests on vagrant'
task default: ['style', 'integration:vagrant']
