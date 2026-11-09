# frozen_string_literal: true

require 'erb'

module Builders
  class TypeBuilder
    MAX_LINE_LENGTH = 120
    DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze

    attr_reader :name, :attributes, :templates_dir

    def initialize(name, attributes, templates_dir:, dependencies:)
      @name = name
      @attributes = deep_dup(attributes)
      @templates_dir = templates_dir
      @dependencies = dependencies
    end

    def build
      if empty_type?
        build_empty_type
      else
        build_full_type
      end
    end

    def self.underscore(camel_cased_word)
      camel_cased_word.to_s.gsub('::', '/')
                      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .tr('-', '_')
                      .downcase
    end

    private

    def empty_type?
      attributes[:type].is_a?(Array)
    end

    def build_empty_type
      attrs = attributes[:type].map { |member| empty_type_member(member.to_s) }
                               .join(" |\n        ")
      render_template('empty_type.erb', name: name, attributes: attrs)
    end

    def empty_type_member(member)
      return "Types::Array.of(#{add_module_types(member.delete_prefix('array:'))})" if member.start_with?('array:')

      add_module_types(member)
    end

    def build_full_type
      process_attributes!
      render_template('type.erb', name: name, attributes: attributes)
    end

    def process_attributes!
      attributes.each_pair do |attr_name, properties|
        process_attribute!(attr_name, properties)
      end
    end

    def process_attribute!(attr_name, properties)
      process_type!(attr_name, properties)
      process_items!(attr_name, properties)

      original_type = properties[:type]
      apply_required!(attr_name, properties, original_type)
      apply_min_max!(attr_name, properties)
      apply_default!(attr_name, properties, original_type)

      normalize_boolean_type!(attr_name)
    end

    def normalize_boolean_type!(attr_name)
      attributes[attr_name][:type] = 'Types::True' if attributes[attr_name][:type] == 'Types::Boolean.default(true)'
      attributes[attr_name][:type] = attributes[attr_name][:type].gsub('Types::Boolean', 'Types::Bool')
    end

    def process_type!(attr_name, properties)
      attributes[attr_name][:type] = if properties[:type].is_a?(Array)
                                       union_type(attr_name, properties)
                                     else
                                       add_module_types(properties[:type])
                                     end
    end

    # Puts one member per line when the union does not fit on the attribute line.
    def union_type(attr_name, properties)
      members = properties[:type].map { |t| add_module_types(t) }
      prefix = "        #{properties[:required] ? 'attribute' : 'attribute?'} :#{attr_name}, "
      return members.join(' | ') if prefix.length + members.join(' | ').length <= MAX_LINE_LENGTH

      members.join(" |\n#{' ' * prefix.length}")
    end

    def process_items!(attr_name, properties)
      if properties[:items].is_a?(String)
        attributes[attr_name][:type] += ".of(#{add_module_types(properties[:items])})"
      elsif properties[:items] && properties[:items][:type] == 'array'
        item_type = add_module_types(properties[:items][:items])
        attributes[attr_name][:type] += ".of(Types::Array.of(#{item_type}))"
      end
    end

    def apply_required!(attr_name, properties, original_type)
      return unless properties[:required_value]

      attributes[attr_name][:type] += ".constrained(eql: #{typecast(original_type, properties[:required_value])})"
    end

    def apply_min_max!(attr_name, properties)
      return unless properties[:min_size] || properties[:max_size]

      constrain = '.constrained(minmax)'
      constrain = properties[:min_size] ? constrain.gsub('min', "min_size: #{properties[:min_size]}, ") : ''
      constrain = constrain.gsub('max', "max_size: #{properties[:max_size]}") if properties[:max_size]
      attributes[attr_name][:type] += constrain
    end

    def apply_default!(attr_name, properties, original_type)
      return if properties[:default].nil?

      attributes[attr_name][:type] += ".default(#{typecast(original_type, properties[:default])})"
    end

    def add_module_types(type)
      return 'Types::Float' if type == 'number'
      return "Types.deferred(:#{type})" if @dependencies.deferred?(owner: name, target: type)

      DRY_TYPES.include?(type) ? "Types::#{type.capitalize}" : type
    end

    def typecast(type, obj)
      type == 'Types::String' ? "'#{obj}'" : obj
    end

    def render_template(template_name, vars)
      template_path = File.join(templates_dir, template_name)
      template = ERB.new(File.read(template_path))

      # Create binding with the variables
      b = binding
      vars.each { |k, v| b.local_variable_set(k, v) }

      template.result(b).gsub("      \n", '')
    end

    def deep_dup(hash)
      hash.transform_values do |v|
        case v
        when Hash then deep_dup(v)
        when Array then v.dup
        else v
        end
      end
    end
  end
end
