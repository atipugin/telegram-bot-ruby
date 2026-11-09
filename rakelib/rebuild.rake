# frozen_string_literal: true

require 'json'
require_relative 'builders/type_builder'
require_relative 'builders/type_dependencies'
require_relative 'builders/endpoints_builder'

# Type files that are written by hand rather than generated from types.json.
HAND_WRITTEN_TYPES = %w[
  base compactable error pattern_matching
  story_area_position
].freeze

# Generating never deletes files, so a type that was renamed or removed from the docs stays behind.
def warn_about_stale_types(names)
  generated = names.map { |name| Builders::TypeBuilder.underscore(name) }
  stale = Dir["#{__dir__}/../lib/telegram/bot/types/*.rb"].map { |path| File.basename(path, '.rb') } -
          generated - HAND_WRITTEN_TYPES
  return if stale.empty?

  warn "Not in data/types.json: #{stale.sort.join(', ')}. " \
       'Delete them, or alias them to the new type and add them to HAND_WRITTEN_TYPES in rakelib/rebuild.rake.'
end

namespace :rebuild do
  desc 'Rebuild types from type_attributes.json'
  task :types do
    types = JSON.parse(File.read("#{__dir__}/../data/types.json"), symbolize_names: true)
    dependencies = Builders::TypeDependencies.new(types)
    templates_dir = "#{__dir__}/templates"

    types.each_pair do |name, attributes|
      builder = Builders::TypeBuilder.new(name.to_s, attributes,
                                          templates_dir: templates_dir, dependencies: dependencies)
      output_path = "#{__dir__}/../lib/telegram/bot/types/#{Builders::TypeBuilder.underscore(name)}.rb"

      File.write(output_path, builder.build)
    end

    warn_about_stale_types(types.keys)
  end

  desc 'Rebuild API endpoints from method_return_types.json'
  task :methods do
    methods = JSON.parse(File.read("#{__dir__}/../data/methods.json"))
    templates_dir = "#{__dir__}/templates"

    builder = Builders::EndpointsBuilder.new(methods, templates_dir: templates_dir)

    File.write "#{__dir__}/../lib/telegram/bot/api/endpoints.rb", builder.build
  end
end
