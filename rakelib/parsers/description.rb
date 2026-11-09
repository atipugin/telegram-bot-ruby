# frozen_string_literal: true

require_relative 'page_object'

module Parsers
  class Description < PageObject
    # A fixed value ends the description: "Type of the result, must be <em>article</em>". Anything after it is a
    # condition, as in "Must be <em>False</em> for callback queries from …".
    FIXED = [/must be /i, %r{must be <em>([^<]+)</em>\.?\s*\z}i].freeze
    RANGE = /must be between (\d+) and (\d+)(?:, or (0x\h+|\d+))?/i.freeze
    DEFAULT = [/Defaults to /i, %r{Defaults to <em>([^<]+)</em>}i].freeze

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
      size_range[1]
    end

    # Allowed values of a number as [min, max] pairs, e.g. "must be between 60 and 86400, or 0x7FFFFFFF" gives two.
    def ranges
      text.scan(RANGE).flat_map do |min, max, extra|
        [[min.to_i, max.to_i], ([Integer(extra)] * 2 if extra)].compact
      end
    end

    private

    # Serializing a cell is slow, so it is only done for the few that mention the phrase.
    def emphasized((mention, pattern))
      node.inner_html[pattern, 1] if text.match?(mention)
    end

    # Lengths of strings. Numbers are checked by value, see #ranges.
    def size_range
      @size_range ||= if (match = text.match(/(\d+)-(\d+) characters/))
                        min = match[1].to_i
                        [(min if min.positive?), match[2].to_i]
                      else
                        []
                      end
    end
  end
end
