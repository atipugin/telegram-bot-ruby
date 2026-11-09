# frozen_string_literal: true

require_relative 'page_object'

module Parsers
  class Description < PageObject
    FIXED = [/must be /i, %r{must be <em>([^<]+)</em>}i].freeze
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

    private

    # Serializing a cell is slow, so it is only done for the few that mention the phrase.
    def emphasized((mention, pattern))
      node.inner_html[pattern, 1] if text.match?(mention)
    end

    def size_range
      @size_range ||= if (match = text.match(/(\d+)-(\d+) characters/))
                        min = match[1].to_i
                        [(min if min.positive?), match[2].to_i]
                      elsif (match = text.match(/must be between (\d+) and (\d+)/))
                        [match[1].to_i, match[2].to_i]
                      else
                        []
                      end
    end
  end
end
