# frozen_string_literal: true

require 'json'
require_relative 'renderers/type_renderer'
require_relative 'renderers/endpoints_renderer'

namespace :rebuild do
  desc 'Rebuild type classes from type_attributes.json'
  task :types do
    input_file = "#{__dir__}/../data/type_attributes.json"

    unless File.exist?(input_file)
      puts "Error: #{input_file} not found. Run 'rake parse:types' first."
      exit 1
    end

    types = JSON.parse(File.read(input_file), symbolize_names: true)

    types.each_pair do |name, attributes|
      renderer = Renderers::TypeRenderer.new(name, attributes)
      filename = name.to_s
                     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                     .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                     .downcase
      File.write("#{__dir__}/../lib/telegram/bot/types/#{filename}.rb", renderer.render)
    end

    puts '✓ Rebuilt types'
    puts "  Generated #{types.size} type classes"
  end

  desc 'Rebuild endpoints from methods.json'
  task :methods do
    input_file = "#{__dir__}/../data/methods.json"

    unless File.exist?(input_file)
      puts "Error: #{input_file} not found. Run 'rake parse:methods' first."
      exit 1
    end

    methods = JSON.parse(File.read(input_file))
    renderer = Renderers::EndpointsRenderer.new(methods)

    File.write("#{__dir__}/../lib/telegram/bot/api/endpoints.rb", renderer.render)

    puts '✓ Rebuilt methods'
    puts "  Generated #{methods.size} endpoints"
  end
end
