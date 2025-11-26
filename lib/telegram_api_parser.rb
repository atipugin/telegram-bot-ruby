#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'

# Parser for Telegram Bot API documentation
# Generates type_attributes.json from https://core.telegram.org/bots/api
class TelegramApiParser
  TYPE_MAPPING = {
    'Integer' => 'integer',
    'String' => 'string',
    'Boolean' => 'boolean',
    'Float' => 'float',
    'True' => 'boolean',
    'Int' => 'integer'
  }.freeze

  UNION_KEYWORDS = [
    /can be one of/i,
    /it can be one of/i,
    /should be one of/i,
    /represents one of/i,
    /currently,? the following \d+/i,
    /currently support(s|ed)? (results of the |the )?following \d+/i,
    /This object describes.*(it can be|one of)/i
  ].freeze

  EMPTY_TYPE_KEYWORDS = [
    /currently holds no information/i,
    /placeholder.*holds no information/i
  ].freeze

  def initialize(url = 'https://core.telegram.org/bots/api')
    @url = URI(url)
    @doc = nil
    @types = {}
  end

  def fetch
    puts "Fetching #{@url}..."
    response = Net::HTTP.get_response(@url)
    raise "Failed to fetch: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    @doc = Nokogiri::HTML(response.body)
    puts "✓ Fetched successfully"
  end

  def parse
    return unless @doc

    type_count = 0
    union_count = 0
    empty_count = 0

    # Find all h4 headers (type definitions)
    @doc.css('h4').each do |header|
      type_name = header.text.strip
      next if type_name.empty?

      # Detect type category
      description = get_description(header)
      table = find_following_table(header)
      list = find_following_list(header)

      if union_type?(description, table, list)
        parse_union_type(type_name, header, list)
        union_count += 1
      elsif empty_type?(description, table)
        parse_empty_type(type_name)
        empty_count += 1
      elsif table && is_type_table?(table)
        parse_regular_type(type_name, header, table)
        type_count += 1
      end
    end

    puts "\nParsing complete:"
    puts "  Regular types: #{type_count}"
    puts "  Union types: #{union_count}"
    puts "  Empty types: #{empty_count}"
    puts "  Total: #{@types.size}"

    @types
  end

  private

  def union_type?(description, table, list)
    return false unless description && list

    # Union types have a description with keywords and a list, but no table
    has_union_keyword = UNION_KEYWORDS.any? { |pattern| description.match?(pattern) }
    has_union_keyword && !table
  end

  def empty_type?(description, table)
    return false unless description
    return false if table

    EMPTY_TYPE_KEYWORDS.any? { |pattern| description.match?(pattern) }
  end

  def is_type_table?(table)
    headers = table.css('thead tr th, tr:first-child th').map(&:text).map(&:strip)
    headers == ['Field', 'Type', 'Description']
  end

  def parse_union_type(type_name, header, list)
    return unless list

    # Extract member type names from the list
    members = []
    list.css('li').each do |li|
      link = li.css('a').first
      member_name = link ? link.text.strip : li.text.strip.split("\n").first&.strip
      members << member_name if member_name && !member_name.empty?
    end

    if members.any?
      @types[type_name] = { 'type' => members }
      puts "  Union: #{type_name} (#{members.size} members)"
    end
  end

  def parse_empty_type(type_name)
    @types[type_name] = {}
    puts "  Empty: #{type_name}"
  end

  def parse_regular_type(type_name, header, table)
    attributes = {}

    table.css('tbody tr, tr').each do |row|
      cells = row.css('td')
      next if cells.size < 3

      field_name = cells[0].text.strip
      type_html = cells[1].inner_html.strip
      description_text = cells[2].text.strip

      next if field_name.empty?
      next if field_name == 'Field' # Skip header row if it's in tbody

      attribute = parse_attribute(field_name, type_html, description_text)
      attributes[field_name] = attribute if attribute
    end

    if attributes.any?
      @types[type_name] = attributes
      puts "  Type: #{type_name} (#{attributes.size} fields)"
    end
  end

  def parse_attribute(field_name, type_html, description)
    attribute = {}

    # Determine if optional
    is_optional = description.match?(/^optional/i) ||
                  description.match?(/^\*?optional\.\s/i) ||
                  description.match?(/^_optional_/i)
    attribute['required'] = true unless is_optional

    # Parse type information
    type_info = parse_type_info(type_html, description)
    attribute.merge!(type_info)

    # Check for default values (especially for True boolean type)
    if type_info['type'] == 'boolean' && type_html.include?('True')
      attribute['default'] = true
    end

    # Check for special required_value (discriminator fields for union type members)
    if (match = description.match(/must be (.+?)(?:\.|,|$)/i))
      value = match[1].strip.gsub(/^['"]|['"]$/, '')
      # This is likely a discriminator field
      if field_name == 'type' || field_name == 'source'
        attribute['required_value'] = value
        attribute['default'] = value
      end
    end

    attribute
  end

  def parse_type_info(type_html, description)
    # Parse HTML fragment to extract type text
    doc = Nokogiri::HTML.fragment(type_html)
    type_text = doc.text.strip

    # Handle arrays: "Array of X"
    if (match = type_text.match(/^Array of (.+)$/i))
      item_type = match[1].strip
      item_type = extract_type_name(item_type)

      return {
        'type' => 'array',
        'items' => map_type(item_type)
      }
    end

    # Handle union types: "A or B" or "A, B or C" or "A and B"
    if type_text.match?(/\s+or\s+|\s+and\s+/i)
      # For inline unions, take the first type
      # (These are usually documented as separate fields anyway)
      first_type = type_text.split(/\s+(?:or|and)\s+/i).first.split(',').first.strip
      return { 'type' => map_type(extract_type_name(first_type)) }
    end

    # Single type
    type_name = extract_type_name(type_text)
    { 'type' => map_type(type_name) }
  end

  def extract_type_name(text)
    # Extract clean type name from text
    text.strip
        .gsub(/\s*\(.*?\)/, '') # Remove parenthetical notes
        .split(/\s+/).first # Take first word
        .strip
  end

  def map_type(type_name)
    TYPE_MAPPING[type_name] || type_name
  end

  def find_following_table(header)
    current = header.next_element
    while current && current.name != 'h4' && current.name != 'h3'
      return current if current.name == 'table'
      current = current.next_element
    end
    nil
  end

  def find_following_list(header)
    current = header.next_element
    count = 0
    while current && current.name != 'h4' && current.name != 'h3' && count < 5
      return current if current.name == 'ul'
      current = current.next_element
      count += 1
    end
    nil
  end

  def get_description(header)
    current = header.next_element
    descriptions = []

    # Collect all paragraph descriptions before table/list
    while current && current.name != 'h4' && current.name != 'h3'
      break if current.name == 'table' || current.name == 'ul'

      descriptions << current.text.strip if current.name == 'p'
      current = current.next_element
    end

    descriptions.join(' ')
  end

  public

  def to_json
    # Sort types alphabetically for consistency
    sorted_types = @types.keys.sort.each_with_object({}) do |key, hash|
      hash[key] = @types[key]
    end

    JSON.pretty_generate(sorted_types)
  end

  def save(filename)
    File.write(filename, to_json)
    puts "\n✓ Saved to #{filename}"
  end

  def add_custom_types!
    # Add Error type (custom type for API error responses, not in official docs)
    @types['Error'] = {
      'ok' => {
        'type' => 'boolean',
        'required' => true
      },
      'error_code' => {
        'type' => 'integer',
        'required' => true
      },
      'description' => {
        'type' => 'string',
        'required' => true
      },
      'parameters' => {
        'type' => 'ResponseParameters'
      }
    }

    puts "  Custom: Error (added manually)"
  end
end

# CLI execution
if __FILE__ == $PROGRAM_NAME
  puts "=" * 80
  puts "Telegram Bot API Type Attributes Generator"
  puts "=" * 80
  puts ""

  parser = TelegramApiParser.new
  parser.fetch
  parser.parse
  parser.add_custom_types!

  output_file = ARGV[0] || 'data/type_attributes_new.json'
  parser.save(output_file)

  puts ""
  puts "=" * 80
  puts "Summary:"
  puts "  Generated #{parser.instance_variable_get(:@types).size} types"
  puts "  File: #{output_file}"
  puts "=" * 80
end
