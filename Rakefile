require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = false
  task.options = %w(--force-exclusion)
  task.patterns = %w(lib/**/*.rb)
end

task default: :rubocop
