# frozen_string_literal: true

require 'json'
require 'erb'

desc 'Rebuild types'
task :rebuild_types do
  types = JSON.parse(File.read("#{__dir__}/../utility/type_attributes.json"), symbolize_names: true)

  types.each_pair do |name, attributes|
    attributes.delete(:inherited_from)
    if attributes[:type].instance_of?(Array)
      attributes = attributes[:type].join(" |\n        ")
      template = ERB.new(File.read("#{__dir__}/../utility/empty_type.erb"))
    else
      template = ERB.new(File.read("#{__dir__}/../utility/type.erb"))
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
        if properties[:required_value]
          attributes[attr_name][:type] += ".constrained(eql: #{typecast_default(original_type,
                                                                                properties[:required_value])})"
        end
        if properties[:min_size] || properties[:max_size]
          constrain = '.constrained(minmax)'
          constrain = properties[:min_size] ? constrain.gsub('min', "min_size: #{properties[:min_size]}, ") : ''
          constrain = constrain.gsub('max', "max_size: #{properties[:max_size]}") if properties[:max_size]
          attributes[attr_name][:type] += constrain
        end
        unless properties[:default].nil?
          attributes[attr_name][:type] += ".default(#{typecast_default(original_type,
                                                                       properties[:default])})"
        end
        attributes[attr_name][:type] = 'Types::True' if attributes[attr_name][:type] == 'Types::Boolean.default(true)'
        attributes[attr_name][:type] = attributes[attr_name][:type].gsub('Types::Boolean', 'Types::Bool')
      end
    end

    File.write "#{__dir__}/../lib/telegram/bot/types/#{underscore(name)}.rb",
               template.result(binding).gsub("      \n", '')
  end
end
