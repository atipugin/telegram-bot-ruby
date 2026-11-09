# frozen_string_literal: true

require 'json'

module Parsers
  class Serializer
    PRIMITIVES = {
      'String' => 'string',
      'Integer' => 'integer',
      'Boolean' => 'boolean',
      'Float' => 'number',
      'True' => 'boolean'
    }.freeze

    FILES = { types: :types, methods: :api_methods }.freeze

    def self.path(file)
      File.expand_path("../../data/#{file}.json", __dir__)
    end

    def initialize(page)
      @page = page
    end

    def render(file)
      JSON.pretty_generate(public_send(FILES.fetch(file)))
    end

    def types
      @page.api_types.to_h { |type| [type.name, type.is_a?(UnionType) ? union(type) : fields(type)] }
    end

    def api_methods
      @page.api_methods.to_h { |method| [method.name, method.return_type] }
    end

    private

    def union(type)
      members = []
      members << 'string' if type.accepts_string?
      members << "array:#{type.name}" if type.accepts_array_of_self?

      { 'type' => members + type.members }
    end

    def fields(type)
      type.fields.to_h { |field| [field.name, attribute(field)] }
    end

    def attribute(field)
      fixed = field.description.fixed_value
      fixed = cast(fixed, field.type) unless fixed.nil?

      type_ref(field.type).merge(
        'required' => (true if field.required?),
        'required_value' => fixed,
        'default' => fixed.nil? ? default(field) : fixed,
        'min_size' => field.description.min_size,
        'max_size' => field.description.max_size
      ).compact
    end

    def type_ref(type)
      return { 'type' => 'array', 'items' => items(type.items) } if type.array?

      { 'type' => type.union? ? type.names.map { |name| primitive(name) } : primitive(type.names.first) }
    end

    def items(type)
      type.array? ? type_ref(type) : type_ref(type)['type']
    end

    def primitive(name)
      PRIMITIVES.fetch(name, name)
    end

    def default(field)
      return true if field.type.always_true?

      value = field.description.default
      cast(value, field.type) if value
    end

    def cast(value, type)
      case type.to_s
      when 'Integer' then value.to_i
      when 'Boolean' then value.casecmp?('true')
      when 'Float' then value.to_f
      else value
      end
    end
  end
end
