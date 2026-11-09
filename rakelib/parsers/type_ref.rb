# frozen_string_literal: true

require_relative 'error'

module Parsers
  class TypeRef
    ARRAY_PREFIX = 'Array of '
    UNION_SEPARATOR = ' or '
    NAME_PATTERN = '[A-Z][A-Za-z0-9]*'
    NAME = /\A#{NAME_PATTERN}\z/.freeze

    attr_reader :names

    def initialize(text)
      @text = text.to_s.strip
      @names = @text.sub(/\A(?:#{ARRAY_PREFIX})+/o, '').split(UNION_SEPARATOR)

      raise Error, "Unsupported type #{@text.inspect}" unless @names.any? && @names.all?(NAME)
    end

    def array?
      @text.start_with?(ARRAY_PREFIX)
    end

    def union?
      names.size > 1
    end

    def items
      self.class.new(@text.delete_prefix(ARRAY_PREFIX)) if array?
    end

    # A "True" field is only ever sent as true, unlike a "Boolean" one.
    def always_true?
      @text == 'True'
    end

    def to_s
      @text
    end
  end
end
