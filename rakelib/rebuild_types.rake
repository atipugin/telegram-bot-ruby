# frozen_string_literal: true

require 'json'
require 'erb'
DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze

desc 'Rebuild types'
task :rebuild_types do
  types = JSON.parse(File.read("#{__dir__}/../data/type_attributes.json"), symbolize_names: true)

  types.each_pair do |name, attributes|
    next build_empty_type(name, attributes) if attributes[:type].instance_of?(Array)

    attributes.each_pair do |attr_name, properties|
      attributes[attr_name][:type] = add_module_types(properties[:type]) unless properties[:type].is_a?(Array)
      if properties[:type].is_a?(Array)
        attributes[attr_name][:type] = properties[:type].map do |type|
          add_module_types(type)
        end.join(' | ')
      end

      if properties[:items].instance_of?(String)
        attributes[attr_name][:type] += ".of(#{add_module_types(properties[:items])})"
      elsif properties[:items] && properties[:items][:type] == 'array'
        attributes[attr_name][:type] += ".of(Types::Array.of(#{properties[:items][:items]}))"
      end
      original_type = properties[:type]

      attributes = apply_required(attributes, attr_name, properties, original_type)
      attributes = apply_min_max(attributes, attr_name, properties)
      attributes = apply_default(attributes, attr_name, properties, original_type)

      attributes[attr_name][:type] = 'Types::True' if attributes[attr_name][:type] == 'Types::Boolean.default(true)'
      attributes[attr_name][:type] = attributes[attr_name][:type].gsub('Types::Boolean', 'Types::Bool')
    end

    File.write "#{__dir__}/../lib/telegram/bot/types/#{underscore(name)}.rb",
               ERB.new(File.read("#{__dir__}/templates/type.erb")).result(binding).gsub("      \n", '')
  end
end

def build_empty_type(name, attributes)
  attributes = attributes[:type].join(" |\n        ")
  File.write "#{__dir__}/../lib/telegram/bot/types/#{underscore(name)}.rb",
             ERB.new(File.read("#{__dir__}/templates/empty_type.erb")).result(binding).gsub("      \n", '')
end

def apply_default(attributes, attr_name, properties, original_type)
  return attributes if properties[:default].nil?

  attributes[attr_name][:type] += ".default(#{typecast(original_type,
                                                       properties[:default])})"
  attributes
end

def apply_required(attributes, attr_name, properties, original_type)
  return attributes unless properties[:required_value]

  attributes[attr_name][:type] += ".constrained(eql: #{typecast(original_type,
                                                                properties[:required_value])})"
  attributes
end

def apply_min_max(attributes, attr_name, properties)
  return attributes unless properties[:min_size] || properties[:max_size]

  constrain = '.constrained(minmax)'
  constrain = properties[:min_size] ? constrain.gsub('min', "min_size: #{properties[:min_size]}, ") : ''
  constrain = constrain.gsub('max', "max_size: #{properties[:max_size]}") if properties[:max_size]
  attributes[attr_name][:type] += constrain
  attributes
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

def typecast(type, obj)
  type == 'Types::String' ? "'#{obj}'" : obj
end
