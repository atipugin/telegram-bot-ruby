# frozen_string_literal: true

require 'erb'

module Builders
  class EndpointsBuilder
    attr_reader :methods, :templates_dir

    def initialize(methods, templates_dir:)
      @methods = methods.transform_values { |type| convert_to_types_format(type) }
      @templates_dir = templates_dir
    end

    def build
      template_path = File.join(templates_dir, 'endpoints.erb')
      template = ERB.new(File.read(template_path), trim_mode: '-')

      b = binding
      b.local_variable_set(:methods, methods)

      template.result(b)
    end

    private

    def convert_to_types_format(type)
      return convert_union_type(type) if type.include?(' | ')

      convert_single_type(type)
    end

    def convert_union_type(type)
      type.split(' | ').map { |t| convert_to_types_format(t.strip) }.join(' | ')
    end

    def convert_single_type(type)
      return convert_array_type(type) if type.start_with?('Array<')

      convert_primitive_type(type)
    end

    def convert_array_type(type)
      inner_type = type.match(/Array<(.+)>/)[1]
      "Types::Array.of(#{convert_to_types_format(inner_type)})"
    end

    def convert_primitive_type(type)
      type == 'Boolean' ? 'Types::Bool' : "Types::#{type}"
    end
  end
end
