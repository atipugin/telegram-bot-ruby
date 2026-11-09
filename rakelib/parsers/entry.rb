# frozen_string_literal: true

require_relative 'error'
require_relative 'readers'

module Parsers
  # No element contains an entry, so it is not a page object over one node: it
  # is a heading and the blocks that follow it, read by tag.
  class Entry
    extend Readers

    attr_reader :heading, :body

    def initialize(heading, body)
      @heading = heading
      @body = body
      validate!
    rescue Error => e
      raise Error, "#{name}: #{e.message}"
    end

    def name
      @name ||= heading.text.strip
    end

    class << self
      def blocks(name, tag)
        reader(name) { body.select { |block| block.name == tag } }
      end

      def block(name, tag, as: nil)
        reader(name) do
          matches = body.select { |block| block.name == tag }
          raise Error, "has #{matches.size} <#{tag}> blocks" if matches.size > 1

          as && matches.any? ? as.new(matches.first) : matches.first
        end
      end
    end

    private

    def validate!; end
  end
end
