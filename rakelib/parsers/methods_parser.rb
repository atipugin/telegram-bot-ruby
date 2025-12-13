# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module Parsers
  class MethodsParser
    API_URL = 'https://core.telegram.org/bots/api'

    def parse
      doc = fetch_document
      result = {}

      method_headers(doc).each do |header|
        method_name = extract_method_name(header)
        next unless method_name

        return_type = extract_return_type(header)
        result[method_name] = return_type if return_type
      end

      result
    end

    private

    def fetch_document
      Nokogiri::HTML(URI.open(API_URL))
    end

    def method_headers(doc)
      doc.css('h4')
    end

    def extract_method_name(header)
      name = header.text.strip
      # Methods start with lowercase letter (camelCase)
      # Types start with uppercase (PascalCase) - skip those
      return nil unless name.match?(/\A[a-z][a-zA-Z0-9]*\z/)

      name
    end

    def extract_return_type(header)
      # Find description paragraphs after the header
      sibling = header.next_element

      while sibling
        break if sibling.name == 'h4' # Next section

        if sibling.name == 'p'
          return_type = parse_return_statement(sibling)
          return return_type if return_type
        end

        sibling = sibling.next_element
      end

      nil
    end

    def parse_return_statement(paragraph)
      html = paragraph.inner_html

      # Pattern: Returns an Array of <a>Type</a>
      if (match = html.match(%r{Returns an Array of <a[^>]*>([^<]+)</a>}i))
        return "Array<#{match[1]}>"
      end

      # Pattern: On success, an array of <a>Type</a> (lowercase)
      if (match = html.match(%r{On success,? an array of <a[^>]*>([^<]+)</a>}i))
        return "Array<#{match[1]}>"
      end

      # Pattern: Returns a <a>Type</a> or Returns the <a>Type</a>
      if (match = html.match(%r{Returns (?:a |the )?.*?<a[^>]*>([^<]+)</a>}i))
        return match[1]
      end

      # Pattern: Returns basic information ... in form of a <a>Type</a>
      if (match = html.match(%r{in form of a <a[^>]*>([^<]+)</a>}i))
        return match[1]
      end

      # Pattern: <a>Type</a> is returned, otherwise True is returned (union type)
      # e.g., "the edited Message is returned, otherwise True is returned"
      if (match = html.match(%r{<a[^>]*>([^<]+)</a> is returned,? otherwise <em>True</em> is returned}i))
        return "#{match[1]} | Boolean"
      end

      # Pattern: Returns <em>True</em> or On success, <em>True</em> is returned
      return 'Boolean' if html.match?(%r{<em>True</em>(?:\s+(?:is|on)|\s*\.)}i)

      # Pattern: On success, a <a>Type</a> object is returned
      if (match = html.match(%r{On success,? a <a[^>]*>([^<]+)</a> object is returned}i))
        return match[1]
      end

      # Pattern: On success, the <a>Type</a> is returned / the edited/sent/stopped <a>X</a> is returned
      if (match = html.match(%r{the (?:sent |edited |stopped )?<a[^>]*>([^<]+)</a> is returned}i))
        return match[1]
      end

      # Pattern: Returns <em>Int</em> or Integer
      return 'Integer' if html.match?(%r{Returns <em>Int</em>}i)

      # Pattern: Returns ... as <em>String</em>
      return 'String' if html.match?(%r{as <em>String</em>}i)

      nil
    end
  end
end
