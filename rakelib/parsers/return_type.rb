# frozen_string_literal: true

require_relative 'type_ref'

module Parsers
  # The docs only say what a method returns in prose. The first sentence that
  # both mentions returning and names a type wins: a linked object or an
  # emphasized primitive.
  module ReturnType
    PRIMITIVES = { 'True' => 'Boolean', 'Int' => 'Integer', 'Integer' => 'Integer', 'String' => 'String' }.freeze

    MENTION = /\breturn(?:s|ed)?\b/i.freeze
    OBJECT = %r{<a[^>]*>(#{TypeRef::NAME_PATTERN})</a>}.freeze
    ARRAY = /\barray of <a/i.freeze
    PRIMITIVE = %r{<em>(#{Regexp.union(PRIMITIVES.keys)})</em>}.freeze
    OR_TRUE = %r{otherwise <em>True</em> is returned}i.freeze

    module_function

    def parse(paragraphs)
      sentences = paragraphs.flat_map { |html| html.split(/(?<=\.)\s+/) }
      sentences.lazy.filter_map { |sentence| parse_sentence(sentence) }.first
    end

    def parse_sentence(sentence)
      return unless sentence.match?(MENTION)

      if (object = sentence[OBJECT, 1])
        type = sentence.match?(ARRAY) ? "Array<#{object}>" : object
        sentence.match?(OR_TRUE) ? "#{type} | Boolean" : type
      elsif (primitive = sentence[PRIMITIVE, 1])
        PRIMITIVES.fetch(primitive)
      end
    end
  end
end
