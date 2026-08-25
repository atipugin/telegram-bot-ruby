# frozen_string_literal: true

module Docs
  # An index of a node's inline markup: which tag sits at which offset into
  # the node's plain text. This is what lets a prose query be anchored to a
  # phrase ("the <em> right after 'must be'") without regexing raw HTML.
  class Marks
    include Enumerable

    Mark = Struct.new(:offset, :tag, :value)

    INLINE = %w[a em strong code].freeze

    def initialize(node)
      @marks = []
      index(node, 0)
      @marks.freeze
    end

    def each(&block)
      @marks.each(&block)
    end

    def values_for(tag)
      select { |mark| mark.tag == tag }.map(&:value)
    end

    def last_before(tag, offset)
      reverse_each.find { |mark| mark.tag == tag && mark.offset < offset }
    end

    def first_from(offset)
      find { |mark| mark.offset >= offset }
    end

    def first_from_with_tag(tag, offset)
      find { |mark| mark.tag == tag && mark.offset >= offset }
    end

    private

    def index(node, offset)
      node.children.each { |child| offset = index_child(child, offset) }
      offset
    end

    # Zero-length elements contribute nothing: the page carries 630 empty
    # <a class="anchor"> and <i class="anchor-icon"> nodes, and counting them
    # would shift every offset that follows.
    def index_child(child, offset)
      length = child.text.length
      return offset + length if child.text? || length.zero?

      if INLINE.include?(child.name)
        @marks << Mark.new(offset, child.name, child.text.strip)
      else
        index(child, offset)
      end

      offset + length
    end
  end
end
