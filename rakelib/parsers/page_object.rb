# frozen_string_literal: true

require 'nokogiri'
require_relative 'error'
require_relative 'readers'

module Parsers
  class PageObject
    extend Readers

    attr_reader :node

    def initialize(node)
      @node = node
      validate!
    end

    class << self
      def texts(name, selector)
        reader(name) { node.css(selector).map { |match| match.text.strip } }
      end

      def elements(name, selector)
        reader(name) { node.css(selector).to_a }
      end

      # Reads a child by position, which is much cheaper than a selector per
      # table cell.
      def cell(name, index, as: nil)
        reader(name) do
          child = node.element_children[index] || raise(Error, "No cell #{index} in #{node.text.strip.inspect}")
          as ? as.new(child) : child.text.strip
        end
      end
    end

    private

    def validate!; end
  end
end
