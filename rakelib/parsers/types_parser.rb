# frozen_string_literal: true

require 'nokogiri'
require 'net/http'

module Parsers
  class TypesParser
    API_URL = 'https://core.telegram.org/bots/api'

    PRIMITIVE_TYPES = {
      'String' => 'string',
      'Integer' => 'integer',
      'Boolean' => 'boolean',
      'Float' => 'number',
      'True' => 'boolean'
    }.freeze

    def parse
      doc = fetch_document
      result = {}

      type_headers(doc).each do |header|
        type_name = extract_type_name(header)
        next unless type_name

        type_data = parse_type(header, type_name)
        result[type_name] = type_data if type_data
      end

      result
    end

    private

    def fetch_document
      uri = URI.parse(API_URL)
      response = Net::HTTP.get(uri)
      Nokogiri::HTML(response)
    end

    def type_headers(doc)
      doc.css('h4')
    end

    def extract_type_name(header)
      name = header.text.strip
      # Types start with uppercase letter (CapitalCase)
      # Methods start with lowercase (camelCase) - skip those
      return nil unless name.match?(/\A[A-Z][a-zA-Z0-9]*\z/)

      name
    end

    def parse_type(header, _type_name)
      # Check if this is a union type (list of types without a table)
      next_sibling = find_next_significant_sibling(header)

      if union_type?(next_sibling)
        parse_union_type(next_sibling)
      else
        parse_table_type(header)
      end
    end

    def find_next_significant_sibling(header)
      sibling = header.next_element
      # Skip description paragraphs
      sibling = sibling.next_element while sibling && sibling.name == 'p'
      sibling
    end

    def union_type?(element)
      element&.name == 'ul'
    end

    def parse_union_type(ul_element)
      types = ul_element.css('li a').map { |a| a.text.strip }
      { 'type' => types }
    end

    def parse_table_type(header)
      table = find_attribute_table(header)
      return {} unless table

      attributes = {}
      table.css('tbody tr').each do |row|
        cells = row.css('td')
        next unless cells.length >= 3

        field_name = cells[0].text.strip
        type_info = cells[1]
        description_cell = cells[2]

        attributes[field_name] = parse_attribute(type_info, description_cell)
      end

      attributes
    end

    def find_attribute_table(header)
      sibling = header.next_element
      while sibling
        return sibling if sibling.name == 'table'
        # Stop if we hit another h4 (next type/method)
        break if sibling.name == 'h4'

        sibling = sibling.next_element
      end
      nil
    end

    def parse_attribute(type_cell, description_cell)
      attribute = {}
      raw_type = type_cell.text.strip
      description = description_cell.text.strip
      description_html = description_cell.inner_html

      # Parse type
      type_value = parse_type_value(type_cell)
      if type_value.is_a?(Hash)
        attribute.merge!(type_value)
      else
        attribute['type'] = type_value
      end

      # Parse required (absence of "Optional" at start of description)
      attribute['required'] = true unless description.start_with?('Optional')

      # Parse required_value (always "X" or must be <em>X</em>)
      required_value = extract_required_value(description, description_html)
      if required_value
        attribute['required_value'] = required_value
        attribute['default'] = required_value
      end

      # Parse size constraints (N-M characters or must be between)
      min_size, max_size = extract_size_constraints(description)
      attribute['min_size'] = min_size if min_size
      attribute['max_size'] = max_size if max_size

      # Parse default value (Defaults to X)
      # If HTML type is 'True' (not 'Boolean'), it means the field only exists when true
      if raw_type == 'True' && !attribute.key?('default')
        attribute['default'] = true
      elsif !attribute.key?('default')
        default = extract_default_value(description, description_html, attribute['type'])
        attribute['default'] = default unless default.nil?
      end

      # Clean up: remove required if false
      attribute.delete('required') unless attribute['required']

      attribute
    end

    def parse_type_value(type_cell)
      text = type_cell.text.strip
      links = type_cell.css('a')

      # Check for "Array of X"
      if text.start_with?('Array of')
        items_type = parse_array_items(type_cell, text)
        return { 'type' => 'array', 'items' => items_type }
      end

      # Check for union type "X or Y"
      if text.include?(' or ')
        types = parse_union_types(type_cell, text)
        return types.length == 1 ? normalize_type(types.first) : types.map { |t| normalize_type(t) }
      end

      # Single type
      if links.any?
        normalize_type(links.first.text.strip)
      else
        normalize_type(text)
      end
    end

    def parse_array_items(type_cell, text)
      # Handle "Array of Array of X"
      if text.include?('Array of Array of')
        inner_type = type_cell.css('a').last&.text&.strip || text.split('Array of Array of').last.strip
        return { 'type' => 'array', 'items' => normalize_type(inner_type) }
      end

      # Regular "Array of X"
      link = type_cell.css('a').first
      if link
        normalize_type(link.text.strip)
      else
        # Primitive array like "Array of String"
        items_text = text.sub('Array of ', '').strip
        normalize_type(items_text)
      end
    end

    def parse_union_types(type_cell, text)
      links = type_cell.css('a')
      if links.any?
        links.map { |l| l.text.strip }
      else
        text.split(' or ').map(&:strip)
      end
    end

    def normalize_type(type)
      PRIMITIVE_TYPES[type] || type
    end

    def extract_required_value(description, description_html)
      # Pattern: always "X" or always "X" (smart quotes)
      match = description.match(/always ["\u201c]([^"\u201d]+)["\u201d]/i)
      return match[1].delete('\\') if match

      # Pattern: must be <em>X</em> (check inner HTML)
      match = description_html.match(%r{must be <em>([^<]+)</em>}i)
      return match[1] if match

      nil
    end

    def extract_size_constraints(description)
      min_size = nil
      max_size = nil

      # Pattern: N-M characters (covers 0-N and 1-N cases)
      if (match = description.match(/(\d+)-(\d+) characters/))
        min_val = match[1].to_i
        max_size = match[2].to_i
        min_size = min_val if min_val.positive?
      # Pattern: must be between N and M
      elsif (match = description.match(/must be between (\d+) and (\d+)/))
        min_size = match[1].to_i
        max_size = match[2].to_i
      end

      [min_size, max_size]
    end

    def extract_default_value(description, description_html, type)
      # Pattern: Defaults to "X" (with smart quotes U+201C/U+201D)
      if (match = description.match(/Defaults to \u201c([^\u201d]+)\u201d/i))
        return cast_default_value(match[1], type)
      end

      # Pattern: Defaults to <em>X</em> (check inner HTML for em-wrapped values)
      if (match = description_html.match(%r{Defaults to <em>([^<]+)</em>}i))
        return cast_default_value(match[1], type)
      end

      # Pattern: Defaults to <number> (plain numeric values)
      if (match = description.match(/Defaults to (\d+)/i))
        return cast_default_value(match[1], type)
      end

      nil
    end

    def cast_default_value(value, type)
      case type
      when 'integer'
        value.to_i
      when 'boolean'
        value.downcase == 'true'
      when 'number'
        value.to_f
      else
        value
      end
    end
  end
end
