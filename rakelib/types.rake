# frozen_string_literal: true

require 'openapi3_parser'
require 'json'
require 'erb'

module TypesHelper
  DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze

  def self.required_keys(schema)
    schema.required.to_a || []
  end

  def self.apply_default_schema(attribute, property_schema)
    attribute[:default] = property_schema.default unless property_schema.default.nil?
    # previous line would have been enough, but had to check the description due to issue: https://github.com/kevindew/openapi3_parser/issues/28
    attribute[:default] = false if property_schema.description&.include?('Defaults to *false*')
    attribute
  end

  def self.parse_initial_type(property_schema, property_name)
    case property_schema.type
    when nil then property_name.capitalize.gsub(/_(\w)/) { Regexp.last_match(1).upcase }
    when 'object' then property_schema.name
    else property_schema.type
    end
  end

  def self.build_empty_type(name, attributes)
    attributes = attributes[:type].join(" |\n        ")
    File.write "#{__dir__}/../lib/telegram/bot/types/#{underscore(name)}.rb",
               ERB.new(File.read("#{__dir__}/templates/empty_type.erb")).result(binding).gsub("      \n", '')
  end

  def self.apply_default(attributes, attr_name, properties, original_type)
    return attributes if properties[:default].nil?

    attributes[attr_name][:type] += ".default(#{typecast(original_type,
                                                         properties[:default])})"
    attributes
  end

  def self.apply_required(attributes, attr_name, properties, original_type)
    return attributes unless properties[:required_value]

    attributes[attr_name][:type] += ".constrained(eql: #{typecast(original_type,
                                                                  properties[:required_value])})"
    attributes
  end

  def self.apply_min_max(attributes, attr_name, properties)
    return attributes unless properties[:min_size] || properties[:max_size]

    constrain = '.constrained(minmax)'
    constrain = properties[:min_size] ? constrain.gsub('min', "min_size: #{properties[:min_size]}, ") : ''
    constrain = constrain.gsub('max', "max_size: #{properties[:max_size]}") if properties[:max_size]
    attributes[attr_name][:type] += constrain
    attributes
  end

  def self.add_module_types(type)
    return 'Types::Float' if type == 'number'

    DRY_TYPES.include?(type) ? "Types::#{type.capitalize}" : type
  end

  def self.underscore(camel_cased_word)
    camel_cased_word.to_s.gsub('::', '/')
                    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                    .tr('-', '_')
                    .downcase
  end

  def self.typecast(type, obj)
    type == 'Types::String' ? "'#{obj}'" : obj
  end
end

namespace :types do
  desc 'Parse types from public json, should be up to date https://github.com/ark0f/tg-bot-api'
  task :parse_schema do
    document = Openapi3Parser.load_url('https://ark0f.github.io/tg-bot-api/openapi.json')

    result = document.components.schemas.to_h do |type_name, schema|
      type_schema = schema.properties.to_h do |property_name, property_schema|
        attribute = { type: TypesHelper.parse_initial_type(property_schema, property_name) }

        unless property_schema.any_of.nil?
          attribute[:type] = property_schema.any_of.map { |item| property_schema.name || item.name || item.type }.uniq
        end

        # Input File is literally just a string for our purpose
        attribute[:type]&.delete('InputFile')
        attribute[:type] = attribute[:type].join if attribute[:type]&.length == 1

        attribute[:required] = true if TypesHelper.required_keys(schema).include?(property_name)

        # getting required values from the description, no values in json 😔
        required_value = property_schema.description&.match(/always “(.+)”|must be \*(.+)\*/)
        attribute[:required_value] = (required_value[1] || required_value[2]).delete('\\') if required_value

        # for some reason every property's minLength is 0 by default, probably parser bug, had to ignore that
        attribute[:min_size] = property_schema[:minLength] if property_schema[:minLength] != 0
        attribute[:max_size] = property_schema[:maxLength] if property_schema[:maxLength]

        attribute[:items] = property_schema.items.type if property_schema&.items
        if property_schema&.type == 'array' && property_schema&.items&.type.nil?
          attribute[:items] = property_schema&.items&.name
        end

        attribute[:items] = property_schema.items.name if property_schema&.items&.type == 'object'

        # array of arrays
        if property_schema&.items&.type == 'array'
          attribute[:items] = { type: 'array', items: property_schema.items.items.name }
        end

        attribute = TypesHelper.apply_default_schema(attribute, property_schema)
        [property_name, attribute]
      end

      # find empty classes
      type_schema[:type] = schema.any_of.map(&:name) if schema.properties.empty? && schema.any_of
      [type_name, type_schema]
    end

    # Input File is literally just a string for our purpose
    File.write "#{__dir__}/../data/type_attributes.json", JSON.pretty_generate(result.except('InputFile'))
  end

  desc 'Rebuild types'
  task :rebuild_types do
    types = JSON.parse(File.read("#{__dir__}/../data/type_attributes.json"), symbolize_names: true)

    types.each_pair do |name, attributes|
      next TypesHelper.build_empty_type(name, attributes) if attributes[:type].instance_of?(Array)

      attributes.each_pair do |attr_name, properties|
        attributes[attr_name][:type] = TypesHelper.add_module_types(properties[:type]) unless properties[:type].is_a?(Array)
        if properties[:type].is_a?(Array)
          attributes[attr_name][:type] = properties[:type].map do |type|
            TypesHelper.add_module_types(type)
          end.join(' | ')
        end

        if properties[:items].instance_of?(String)
          attributes[attr_name][:type] += ".of(#{TypesHelper.add_module_types(properties[:items])})"
        elsif properties[:items] && properties[:items][:type] == 'array'
          attributes[attr_name][:type] += ".of(Types::Array.of(#{properties[:items][:items]}))"
        end
        original_type = properties[:type]

        attributes = TypesHelper.apply_required(attributes, attr_name, properties, original_type)
        attributes = TypesHelper.apply_min_max(attributes, attr_name, properties)
        attributes = TypesHelper.apply_default(attributes, attr_name, properties, original_type)

        attributes[attr_name][:type] = 'Types::True' if attributes[attr_name][:type] == 'Types::Boolean.default(true)'
        attributes[attr_name][:type] = attributes[attr_name][:type].gsub('Types::Boolean', 'Types::Bool')
      end

      File.write "#{__dir__}/../lib/telegram/bot/types/#{TypesHelper.underscore(name)}.rb",
                 ERB.new(File.read("#{__dir__}/templates/type.erb")).result(binding).gsub("      \n", '')
    end
  end
end
