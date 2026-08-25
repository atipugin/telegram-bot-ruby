# frozen_string_literal: true

require 'erb'

module Builders
  class TypeBuilder
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
                                       properties[:type].map { |t| add_module_types(t) }.join(' | ')
                                     else
                                       add_module_types(properties[:type])
                                     end
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

    # String length limits use min_size/max_size; numeric ranges use
    # gteq/lteq, because dry-types measures `size` and Integer#size is the
    # byte width, which made every numeric range vacuously true.
    CONSTRAINTS = { min_size: :min_size, max_size: :max_size, min: :gteq, max: :lteq }.freeze

    def apply_min_max!(attr_name, properties)
      constrained = CONSTRAINTS.filter_map do |key, predicate|
        "#{predicate}: #{numeral(properties[key])}" if properties[key]
      end
      return if constrained.empty?

      attributes[attr_name][:type] += ".constrained(#{constrained.join(', ')})"
    end

    # Emit 86_400 rather than 86400, so generated files satisfy
    # Style/NumericLiterals without a manual rubocop pass. Its MinDigits is 5,
    # so shorter numbers are left alone.
    NUMERIC_LITERAL_MIN_DIGITS = 5

    def numeral(value)
      digits = value.to_s
      return digits if digits.length < NUMERIC_LITERAL_MIN_DIGITS

      digits.reverse.scan(/\d{1,3}/).join('_').reverse
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
