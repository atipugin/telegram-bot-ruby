# frozen_string_literal: true

require_relative 'table'
require_relative 'text'

module Docs
  # A heading plus the flat run of sibling nodes that follows it, up to the
  # next heading. This is the concept the parsers previously re-derived by
  # hand in four separate next_element walks.
  class Section
    attr_reader :heading, :nodes

    def initialize(heading, nodes = [])
      @heading = heading
      @nodes = nodes
    end

    def title
      @title ||= heading.text.strip
    end

    def level
      @level ||= heading.name[1].to_i
    end

    def paragraphs
      @paragraphs ||= nodes.select { |node| node.name == 'p' }.map { |node| Text.new(node) }
    end

    def intro
      paragraphs.first
    end

    def table
      return @table if defined?(@table)

      node = nodes.find { |candidate| candidate.name == 'table' }
      @table = node && Table.new(node)
    end

    def items
      @items ||= begin
        list = nodes.find { |node| node.name == 'ul' }
        list ? list.css('li').map { |item| Text.new(item) } : []
      end
    end
  end
end
