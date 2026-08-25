# frozen_string_literal: true

module Parsers
  # Maps a "Type" cell to the JSON shape stored in data/types.json.
  class TypeValue
    PRIMITIVES = {
      'String' => 'string',
      'Integer' => 'integer',
      'Boolean' => 'boolean',
      'Float' => 'number',
      'True' => 'boolean'
    }.freeze

    def initialize(cell)
      @cell = cell
    end

    def to_h
      return { 'type' => 'array', 'items' => array_items } if array?

      { 'type' => scalar }
    end

    private

    def text
      @cell.to_s
    end

    def links
      @cell.links
    end

    def array?
      text.start_with?('Array of')
    end

    def array_items
      return nested_items if text.include?('Array of Array of')

      normalize(links.first || text.sub('Array of ', '').strip)
    end

    def nested_items
      inner = links.last || text.split('Array of Array of').last.strip
      { 'type' => 'array', 'items' => normalize(inner) }
    end

    def scalar
      return union if text.include?(' or ')

      normalize(links.first || text)
    end

    def union
      members = links.empty? ? text.split(' or ').map(&:strip) : links
      members.length == 1 ? normalize(members.first) : members.map { |member| normalize(member) }
    end

    def normalize(type)
      PRIMITIVES[type] || type
    end
  end
end
