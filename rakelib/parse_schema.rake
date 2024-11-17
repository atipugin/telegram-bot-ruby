# frozen_string_literal: true

require 'openapi3_parser'
DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze

desc 'Parse types from public json, should be up to date https://github.com/ark0f/tg-bot-api'
task :parse_schema do
  result = {}
  document = Openapi3Parser.load_url('https://ark0f.github.io/tg-bot-api/openapi.json')

  document.components.schemas.each do |schema|
    # Input File is literally just a string for our purpose
    next if schema[0] == 'InputFile'

    result_schema = {}

    schema[1].properties.each do |property|
      required_keys = schema[1].required.to_a || []
      property_name = property[0]
      property_schema = property[1]

      attribute_type =
        case property_schema.type
        when nil then property_name.capitalize.gsub(/_(\w)/) { Regexp.last_match(1).upcase }
        when 'object' then property_schema.name
        else property_schema.type
        end

      attribute = {
        type: attribute_type
      }

      unless property_schema.any_of.nil?
        attribute[:type] = property_schema.any_of.map do |item|
          property_schema.name || item.name || item.type
        end.uniq
      end

      # Input File is literally just a string for our purpose
      attribute[:type]&.delete('InputFile')
      attribute[:type] = attribute[:type].join if attribute[:type]&.length == 1

      attribute[:required] = true if required_keys.include?(property_name)

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
        attribute[:items] = {
          type: 'array',
          items: property_schema&.items&.items&.name
        }
      end

      attribute[:default] = property_schema.default if property_schema.default
      # previous line would have been enough, but had to check the description due to issue: https://github.com/kevindew/openapi3_parser/issues/28
      attribute[:default] = false if property_schema.description&.include?('Defaults to *false*')
      result_schema[property_name] = attribute
    end

    result[schema[0]] = result_schema

    # find empty classes
    result[schema[0]][:type] = schema[1].any_of.map(&:name) if schema[1].properties.empty? && schema[1].any_of
  end

  File.write "#{__dir__}/../utility/type_attributes.json", JSON.pretty_generate(result)
end

def add_module_types(type)
  return 'Types::Float' if type == 'number'

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
