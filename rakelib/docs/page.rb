# frozen_string_literal: true

require 'nokogiri'

require_relative 'error'
require_relative 'section'
require_relative 'source'

module Docs
  # The Bot API documentation page.
  #
  # Its content is a flat stream of sibling elements -- 601 h4, 676 p, 544
  # table, nothing nested -- so the only structure worth modelling is where
  # one heading's run of nodes ends and the next begins.
  class Page
    CONTENT_SELECTOR = '#dev_page_content'
    HEADING = /\Ah([1-6])\z/.freeze

    def self.load(source = Source.new)
      new(source.html)
    end

    def initialize(html)
      @root = Nokogiri::HTML(html).at(CONTENT_SELECTOR) ||
              raise(Error, "#{CONTENT_SELECTOR} not found; the docs layout changed")
    end

    # Every section introduced by a heading at `level`, in document order.
    # Slicing before every heading is what makes an <h3> close an open <h4>
    # section without needing a level stack.
    def sections(level: 4)
      @root.element_children
           .slice_before { |node| heading_level(node) }
           .select { |(heading, *)| heading_level(heading) == level }
           .map { |(heading, *nodes)| Section.new(heading, nodes) }
    end

    private

    def heading_level(node)
      found = HEADING.match(node.name)
      found && found[1].to_i
    end
  end
end
