#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

module DocsParsers
  # Parser for Telegram Bot API documentation methods
  # Generates methods.json with method names and return types
  class MethodsParser
    # Map Telegram API type names to Ruby type representations
    TYPE_MAPPING = {
      'Integer' => 'Types::Integer',
      'String' => 'Types::String',
      'Boolean' => 'Types::Bool',
      'Bool' => 'Types::Bool',
      'True' => 'Types::Bool',
      'Float' => 'Types::Float',
      'Int' => 'Types::Integer'
    }.freeze

    def initialize(url = 'https://core.telegram.org/bots/api')
      @url = URI(url)
      @doc = nil
      @methods = {}
    end

    def fetch
      puts "Fetching #{@url}..."
      html = URI.open(@url).read
      @doc = Nokogiri::HTML(html)
      puts "✓ Fetched successfully"
    end

    def parse
      return unless @doc

      method_count = 0

      # Find all h4 headers that represent methods
      @doc.css('h4').each do |header|
        method_name = header.text.strip
        next if method_name.empty?

        # Skip if it's a type (starts with uppercase)
        next if method_name[0] == method_name[0].upcase

        # Get the description and return type
        description = get_description(header)
        return_type = parse_return_type(method_name, description)

        if return_type
          @methods[method_name] = return_type
          puts "  Method: #{method_name} => #{return_type}"
          method_count += 1
        end
      end

      puts "\nParsing complete:"
      puts "  Total methods: #{method_count}"

      @methods
    end

    private

    def get_description(header)
      current = header.next_element
      descriptions = []

      # Collect all paragraph descriptions before table
      while current && current.name != 'h4' && current.name != 'h3'
        break if current.name == 'table'

        descriptions << current.text.strip if current.name == 'p'
        current = current.next_element
      end

      descriptions.join(' ')
    end

    def parse_return_type(method_name, description)
      return nil if description.empty?

      # Common patterns for return types in Telegram API docs:
      # "Returns X on success"
      # "On success, returns X"
      # "On success, X is returned"
      # "Returns an Array of X objects"
      # "Returns True on success"
      # "Returns Message or True"

      # Pattern 1: "Returns True on success" or "Returns True"
      if description.match?(/returns?\s+True\b/i) && !description.match?(/\s+or\s+/i)
        return 'Types::Bool'
      end

      # Pattern 2: "Returns an Array of X" or "Returns Array of X"
      if (match = description.match(/returns?\s+(?:an?\s+)?Array of\s+(\w+)/i))
        inner_type = match[1].strip
        return "Types::Array.of(#{map_type(inner_type)})"
      end

      # Pattern 3: Union types "Returns X or Y" or "Returns Message or True"
      if (match = description.match(/returns?\s+(?:an?\s+)?(\w+)(?:\s+object)?\s+or\s+(\w+)/i))
        type1 = match[1].strip
        type2 = match[2].strip
        # Handle "Message or True" -> "Types::Message | Types::Bool"
        return "#{map_type(type1)} | #{map_type(type2)}"
      end

      # Pattern 4: "Returns basic information about the bot" -> extract "User" from context
      # Some methods describe what they return without using "Returns X" pattern
      # We'll try to extract the type from phrases like "information about X"
      if description.match?(/information about (?:the )?bot/i)
        return 'Types::User' # getMe returns User
      end

      # Pattern 5: "Returns X on success" or "On success, returns X"
      # Look for common return type patterns
      if (match = description.match(/(?:returns?|returned)\s+(?:an?\s+)?(\w+)(?:\s+(?:object|on success|is returned))?/i))
        type_name = match[1].strip

        # Skip common words that aren't types
        skip_words = %w[False success information object file the a an if when basic]
        return nil if skip_words.include?(type_name)

        # Check if it's a known type
        return map_type(type_name)
      end

      # Pattern 6: "On success, X is returned"
      if (match = description.match(/on success,\s+(?:an?\s+)?(\w+)\s+(?:is|are)\s+returned/i))
        type_name = match[1].strip
        skip_words = %w[information the message]
        return nil if skip_words.include?(type_name)
        return map_type(type_name)
      end

      # Pattern 7: For specific methods with known return types
      # This is a fallback for methods that don't follow standard patterns
      case method_name
      when 'getUpdates'
        'Types::Array.of(Types::Update)'
      when 'setWebhook', 'deleteWebhook'
        'Types::Bool'
      when 'getMe'
        'Types::User'
      else
        nil
      end
    end

    def map_type(type_name)
      # Check if it's a primitive type
      return TYPE_MAPPING[type_name] if TYPE_MAPPING.key?(type_name)

      # Otherwise, assume it's a custom type
      "Types::#{type_name}"
    end

    public

    def to_json
      # Sort methods alphabetically for consistency
      sorted_methods = @methods.keys.sort.each_with_object({}) do |key, hash|
        hash[key] = @methods[key]
      end

      JSON.pretty_generate(sorted_methods)
    end

    def save(filename)
      File.write(filename, to_json)
      puts "\n✓ Saved to #{filename}"
    end
  end
end
