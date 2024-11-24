# frozen_string_literal: true

require 'openapi3_parser'

desc 'Parse types from public json, should be up to date https://github.com/ark0f/tg-bot-api'
task :parse_schema do
  document = Openapi3Parser.load_url('https://ark0f.github.io/tg-bot-api/openapi.json')

  result = document.components.schemas.to_h do |type_name, schema|
    type_schema = schema.properties.to_h do |property_name, property_schema|
      attribute = { type: parse_initial_type(property_schema, property_name) }

      unless property_schema.any_of.nil?
        attribute[:type] = property_schema.any_of.map { |item| property_schema.name || item.name || item.type }.uniq
      end

      # Input File is literally just a string for our purpose
      attribute[:type]&.delete('InputFile')
      attribute[:type] = attribute[:type].join if attribute[:type]&.length == 1

      attribute[:required] = true if required_keys(schema).include?(property_name)

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

      attribute = apply_default_schema(attribute, property_schema)
      [property_name, attribute]
    end

    # find empty classes
    type_schema[:type] = schema.any_of.map(&:name) if schema.properties.empty? && schema.any_of
    [type_name, type_schema]
  end

  # Input File is literally just a string for our purpose
  File.write "#{__dir__}/../data/type_attributes.json", JSON.pretty_generate(result.except('InputFile'))
end

def required_keys(schema)
  schema.required.to_a || []
end

def apply_default_schema(attribute, property_schema)
  attribute[:default] = property_schema.default unless property_schema.default.nil?
  # previous line would have been enough, but had to check the description due to issue: https://github.com/kevindew/openapi3_parser/issues/28
  attribute[:default] = false if property_schema.description&.include?('Defaults to *false*')
  attribute
end

def parse_initial_type(property_schema, property_name)
  case property_schema.type
  when nil then property_name.capitalize.gsub(/_(\w)/) { Regexp.last_match(1).upcase }
  when 'object' then property_schema.name
  else property_schema.type
  end
end
