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

desc 'Dump type definitions from docs to YAML'
task :dump_type_attributes do
  require_relative 'lib/telegram/bot'
  require 'nokogiri'
  require 'open-uri'
  require 'yaml'

  # Preload every type we have
  Zeitwerk::Loader.eager_load_all
  types = Telegram::Bot::Types::Base.descendants.map { |c| c.name.split('::').last }

  # Fetch and parse docs
  doc = Nokogiri::HTML(URI.open('https://core.telegram.org/bots/api').read)

  next_type_element_names = %w[table h4]

  result = types.to_h do |type|
    # This is very hacky but working way to find table containing attributes for
    # given type. Basic idea is to find heading with type and then iterate until
    # we find table with attributes or next heading (because sometimes type
    # doesn't have any attributes).
    element = doc.at_xpath(%{//h4[text() = "#{type}"]})
    loop do
      element = element.next_element
      break if next_type_element_names.include?(element.name)
    end

    attributes = element.xpath('.//tbody//tr').map do |el|
      cells = el.children.select { |c| c.name == 'td' }
      {
        'name' => cells[0].text,
        'type' => cells[1].text,
        'required' => !cells[2].text.start_with?('Optional.'),
        'required_value' =>
          cells[2].text.match(/^.+, (?:must be (?<found_type>\w+)|always “(?<found_type>\w+)”)$/)&.[](:found_type)
      }.compact
    end

    [type, attributes]
  end

  # Write everything to fixture file
  File.write "#{__dir__}/spec/support/type_attributes.yml", result.to_yaml
end

DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze
desc 'Rebuild types'
task :rebuild_types do
  require 'json'
  require 'erb'

  types = JSON.parse(File.read("#{__dir__}/spec/support/openapi_type_attributes.json"), symbolize_names: true)

  types.each_pair do |name, attributes|
    template = ERB.new(File.read("#{__dir__}/spec/support/type.erb"))

    attributes.each_pair do |attr_name, properties|
      attributes[attr_name][:type] = add_module_types(properties[:type]) unless properties[:type].is_a?(Array)
      if properties[:type].is_a?(Array)
        attributes[attr_name][:type] = properties[:type].map do |type|
          add_module_types(type)
        end.join(' | ')
      end
      attributes[attr_name][:type] += ".of(#{add_module_types(properties[:items])})" if properties[:items]
      if properties[:default]
        attributes[attr_name][:type] += ".default(#{typecast_default(properties[:type],
                                                                     properties[:default])})"
      end
      attributes[attr_name][:type] = 'Types::True' if attributes[attr_name][:type] == 'Types::Boolean.default(true)'
      attributes[attr_name][:type] = 'Types::Bool' if attributes[attr_name][:type] == 'Types::Boolean'
    end

    File.write "#{__dir__}/lib/telegram/bot/types/#{underscore(name)}.rb", template.result(binding).gsub("      \n", '')
  end
end

desc 'Parse types from public json, should be up to date https://github.com/ark0f/tg-bot-api'
task :parse_type_attributes_from_opeanapi do
  require 'openapi3_parser'
  result = {}
  document = Openapi3Parser.load_url('https://ark0f.github.io/tg-bot-api/openapi.json')

  document.components.schemas.each do |schema|
    result_schema = {}
    schema[1].properties.each do |property|
      required_keys = schema[1].required.to_a || []

      result_schema[property[0]] = {
        type: property[1].type == 'object' ? property[1].name : property[1].type
      }

      unless property[1].any_of.nil?
        result_schema[property[0]][:type] = property[1].any_of.map do |item|
          property[1].name || item.name || item.type
        end.uniq
      end
      if result_schema[property[0]][:type]&.length == 1
        result_schema[property[0]][:type] =
          result_schema[property[0]][:type].join
      end
      result_schema[property[0]][:required] = true if required_keys.include?(property[0])
      result_schema[property[0]][:items] = property[1].items.type if property[1]&.items
      result_schema[property[0]][:items] = property[1].items.name if property[1]&.items&.type == 'object'
      result_schema[property[0]][:default] = property[1].default if property[1].default
    end
    result[schema[0]] = result_schema
  end

  File.write "#{__dir__}/spec/support/openapi_type_attributes.json", result.to_json
end

def add_module_types(type)
  DRY_TYPES.include?(type) ? "Types::#{type.capitalize}" : type
end

def underscore(camel_cased_word)
  camel_cased_word.to_s.gsub('::', '/')
                  .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                  .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                  .tr('-', '_')
                  .downcase
end

def typecast_default(type, obj)
  type == 'Types::String' ? "'#{obj}'" : obj
end
