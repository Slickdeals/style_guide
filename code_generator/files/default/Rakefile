require 'rspec/core/rake_task'
require 'foodcritic'
require 'rubocop/rake_task'
require 'kitchen/rake_tasks'

task :default => ['test:quick']

namespace :test do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.rspec_opts = %w(
      --color
      --format progress
    ).join(' ')
  end

  FoodCritic::Rake::LintTask.new do |t|
    t.options = { :fail_tags => %w(correctness services libraries deprecated) }
  end

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = %w( recipes/*.rb libraries/*.rb providers/*.rb resources/*.rb
                        spec/**/*.rb test/**/*.rb )
    task.formatters = ['progress']
    task.fail_on_error = false
  end

  Kitchen::RakeTasks.new

  desc 'Run just the quick tests'
  task :quick do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:foodcritic'].invoke
    Rake::Task['test:unit'].invoke
  end

  desc "Run *all* the tests. Tea time."
  task :complete do
    Rake::Task['test:quick'].invoke
    Rake::Task['test:kitchen:all'].invoke
  end

  desc "Run CI tests"
  task :ci do
    Rake::Task['test:complete'].invoke
  end
end
