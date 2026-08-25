# frozen_string_literal: true

require_relative 'marks'

module Docs
  # The text of a documentation node, queryable together with its inline
  # markup.
  #
  # Markup is load-bearing: "Returns <em>True</em>" and "Returns <a>Message</a>"
  # are indistinguishable once the tags are dropped. So is position --
  # paragraphs carry earlier prose links, so "the first link" is not the same
  # as "the link after 'Returns'".
  class Text
    def initialize(node)
      @node = node
    end

    def raw
      @raw ||= @node.text
    end

    def to_s
      @to_s ||= raw.strip
    end

    def start_with?(*prefixes)
      to_s.start_with?(*prefixes)
    end

    def match(pattern)
      to_s.match(pattern)
    end

    def match?(pattern)
      to_s.match?(pattern)
    end

    def inspect
      "#<#{self.class} #{to_s.inspect}>"
    end

    def marks
      @marks ||= Marks.new(@node)
    end

    def links
      marks.values_for('a')
    end

    def emphasised
      marks.values_for('em')
    end

    # The <tag> immediately following `phrase`, with only whitespace between.
    # Adjacency is the point: "The bot must be an administrator ... specify
    # <em>allowed_updates</em>" must not read as a "must be <em>X</em>"
    # constraint merely because an <em> appears later in the sentence.
    def after(phrase, tag)
      each_occurrence(phrase) do |finish|
        mark = marks.first_from(finish)
        next unless mark && mark.tag == tag && raw[finish...mark.offset].strip.empty?

        return mark.value
      end
      nil
    end

    # The first <tag> anywhere after `phrase`. Looser than `after`, for prose
    # that puts arbitrary words in between, as in "Returns basic information
    # about the bot in form of a <a>User</a>".
    def following(phrase, tag)
      index = start_of(phrase)
      index && value_of(marks.first_from_with_tag(tag, index))
    end

    # The last <tag> that starts before `phrase`.
    def before(phrase, tag)
      index = start_of(phrase)
      index && value_of(marks.last_before(tag, index))
    end

    def emphasised_after(phrase)
      after(phrase, 'em')
    end

    def link_after(phrase)
      after(phrase, 'a')
    end

    def link_following(phrase)
      following(phrase, 'a')
    end

    def link_before(phrase)
      before(phrase, 'a')
    end

    # always "photo" / always “photo” -> "photo"
    def quoted_after(phrase)
      found = to_s.match(/#{Regexp.escape(phrase)}\s+["“]([^"”]+)["”]/)
      found && found[1]
    end

    # Defaults to 100 -> "100"
    def number_after(phrase)
      found = to_s.match(/#{Regexp.escape(phrase)}\s+(\d+)/)
      found && found[1]
    end

    private

    def value_of(mark)
      mark&.value
    end

    # Offset where `phrase` (a String or Regexp) first occurs.
    def start_of(phrase)
      found = next_occurrence(phrase, 0)
      found&.first
    end

    # Yields the offset just past each occurrence of `phrase`.
    def each_occurrence(phrase)
      position = 0
      while (found = next_occurrence(phrase, position))
        yield found.last
        position = found.first + 1
      end
    end

    # [start, finish] of the next occurrence of `phrase` at or after `position`.
    def next_occurrence(phrase, position)
      return nil if position > raw.length

      if phrase.is_a?(Regexp)
        found = phrase.match(raw, position)
        found && [found.begin(0), found.end(0)]
      else
        index = raw.index(phrase, position)
        index && [index, index + phrase.length]
      end
    end
  end
end
