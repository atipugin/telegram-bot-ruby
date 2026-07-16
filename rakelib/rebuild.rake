# frozen_string_literal: true

require 'json'
require_relative 'builders/type_builder'
require_relative 'builders/endpoints_builder'

namespace :rebuild do
  desc 'Rebuild types from type_attributes.json'
  task :types do
    types = JSON.parse(File.read("#{__dir__}/../data/types.json"), symbolize_names: true)
    templates_dir = "#{__dir__}/templates"

    types.each_pair do |name, attributes|
      builder = Builders::TypeBuilder.new(name.to_s, attributes, templates_dir: templates_dir)
      output_path = "#{__dir__}/../lib/telegram/bot/types/#{Builders::TypeBuilder.underscore(name)}.rb"

      File.write(output_path, builder.build)
    end
  end

  desc 'Rebuild API endpoints from method_return_types.json'
  task :methods do
    methods = JSON.parse(File.read("#{__dir__}/../data/methods.json"))
    templates_dir = "#{__dir__}/templates"

    builder = Builders::EndpointsBuilder.new(methods, templates_dir: templates_dir)

    File.write "#{__dir__}/../lib/telegram/bot/api/endpoints.rb", builder.build
  end
end
