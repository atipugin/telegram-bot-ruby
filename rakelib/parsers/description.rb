# frozen_string_literal: true

require_relative 'page_object'

module Parsers
  class Description < PageObject
    FIXED = [/must be /i, %r{must be <em>([^<]+)</em>(?!\s+(?:for|if|when|unless)\b)}i].freeze
    DEFAULT = [/Defaults to /i, %r{Defaults to <em>([^<]+)</em>}i].freeze
    SIZE_RANGES = [
      /(\d+)-(\d+) characters(?! after entities parsing)/,
      /(?:List of |; )(\d+)-(\d+) (?:buttons|regular or custom emoji)/,
      /must be between (\d+) and (\d+)/
    ].freeze

    def text
      @text ||= node.text.strip
    end

    def optional?
      text.start_with?('Optional')
    end

    def fixed_value
      text[/always ["“]([^"”]+)["”]/i, 1]&.delete('\\') || emphasized(FIXED)
    end

    def default
      text[/Defaults to “([^”]+)”/i, 1] ||
        emphasized(DEFAULT) ||
        text[/Defaults to (\d+)/i, 1]
    end

    def min_size
      size_range[0]
    end

    def max_size
      text[/Up to (\d+) quoted texts/, 1]&.to_i || size_range[1]
    end

    private

    # Serializing a cell is slow, so it is only done for the few that mention the phrase.
    def emphasized((mention, pattern))
      node.inner_html[pattern, 1] if text.match?(mention)
    end

    def size_range
      @size_range ||= begin
        match = SIZE_RANGES.filter_map { |pattern| text.match(pattern) }.first
        if match
          min = match[1].to_i
          # Omit zero character minimums, but retain explicit collection bounds.
          min = nil if min.zero? && match.regexp == SIZE_RANGES.first
          [min, match[2].to_i]
        else
          []
        end
      end
    end
  end
end
