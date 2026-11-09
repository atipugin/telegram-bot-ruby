# frozen_string_literal: true

require_relative 'page_object'

module Parsers
  class Description < PageObject
    # "Type of the result, must be <em>article</em>" fixes the value, but
    # "Must be <em>False</em> for callback queries from …" only applies in some cases.
    FIXED = [/must be /i, %r{must be <em>([^<]+)</em>(?!\s+(?:for|if|when|unless)\b)}i].freeze
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

    # Only string lengths are limits. Numbers are documented as "must be between 60 and 86400, or 0x7FFFFFFF"
    # or with a range per currency, so their ranges are not limits and are left to the server to check.
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
