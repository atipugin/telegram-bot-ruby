# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = false
  task.options = %w[--force-exclusion]
  task.patterns = %w[{lib,spec}/**/*.rb Rakefile]
  task.requires << 'rubocop-rspec'
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
