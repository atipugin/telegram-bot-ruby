# frozen_string_literal: true

require_relative 'error'

module Parsers
  # The docs page is flat: a heading is followed by its content instead of
  # wrapping it. This splits such a run of elements into entries, a heading
  # plus the blocks up to the next heading of the same or a higher rank, and
  # builds each entry with the first rule it matches.
  class EntryGrammar
    Rule = Struct.new(:entry_class, :named, :with) do
      def match?(name, body)
        name.match?(named) && (with.nil? || body.any? { |block| block.name == with })
      end
    end

    def initialize(heading, &rules)
      @heading = heading
      @boundary = /\Ah[1-#{heading[-1]}]\z/
      @rules = []
      instance_eval(&rules)
    end

    def entry(entry_class, named:, with: nil)
      @rules << Rule.new(entry_class, named, with)
    end

    def skip(named:)
      @rules << Rule.new(nil, named)
    end

    def parse(elements)
      elements.slice_before { |element| element.name.match?(@boundary) }
              .select { |first, *| first.name == @heading }
              .filter_map { |heading, *body| build(heading, body) }
    end

    private

    def build(heading, body)
      name = heading.text.strip
      rule = @rules.find { |candidate| candidate.match?(name, body) }
      raise Error, "Unrecognised heading #{name.inspect}" unless rule

      rule.entry_class&.new(heading, body)
    end
  end
end
