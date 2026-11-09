# frozen_string_literal: true

require_relative 'page_object'
require_relative 'entry_grammar'
require_relative 'api_method'
require_relative 'object_type'
require_relative 'union_type'

module Parsers
  class DocsPage < PageObject
    URL = 'https://core.telegram.org/bots/api'
    SNAPSHOT_PATH = File.expand_path('../../data/bot_api.html', __dir__)
    CONTENT = 'div#dev_page_content'

    # Types, methods and prose such as "Sending files" share the <h4> level,
    # and an entry made of paragraphs alone can be any of them, so names
    # decide. The first matching rule wins; a heading that matches none raises.
    GRAMMAR = EntryGrammar.new('h4') do
      entry ApiMethod, named: /\A[a-z][A-Za-z0-9]*\z/
      entry UnionType, named: TypeRef::NAME, with: 'ul'
      entry ObjectType, named: TypeRef::NAME
      skip named: /\s/
    end

    def self.parse(html)
      content = Nokogiri::HTML(html, nil, 'UTF-8').at_css(CONTENT)
      raise Error, "No #{CONTENT} in the document" unless content

      new(content)
    end

    def self.load(path = SNAPSHOT_PATH)
      parse(File.read(path))
    end

    def entries
      @entries ||= GRAMMAR.parse(node.element_children)
    end

    def api_types
      @api_types ||= entries.grep_v(ApiMethod)
    end

    def api_methods
      @api_methods ||= entries.grep(ApiMethod)
    end

    def api_type(name)
      api_types.find { |type| type.name == name } || raise(Error, "Unknown type #{name}")
    end

    def api_method(name)
      api_methods.find { |method| method.name == name } || raise(Error, "Unknown method #{name}")
    end

    # Only the content is kept: without the site chrome around it, the snapshot
    # changes when the documentation does and at no other time.
    def to_html
      "#{node.to_html(encoding: 'UTF-8')}\n"
    end
  end
end
