#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

# Look for union types - search for specific patterns
union_keywords = [
  'This object represents one of',
  'This object can be one of',
  'This object describes'
]

puts "Searching for union type patterns...\n\n"

# Find headers for known union types
['MessageOrigin', 'ChatMember', 'ReactionType', 'MaybeInaccessibleMessage', 'BackgroundFill'].each do |union_name|
  puts "=" * 80
  puts "Looking for: #{union_name}"
  puts "=" * 80

  # Find the h4 header
  header = doc.css('h4').find { |h| h.text.strip == union_name }

  if header
    puts "Found header!"

    # Get content between this header and next h4
    current = header.next_element
    elements = []

    while current && current.name != 'h4' && elements.size < 5
      elements << { name: current.name, text: current.text.strip[0..200] }

      if current.name == 'p'
        union_keywords.each do |keyword|
          if current.text.include?(keyword)
            puts "  *** Found union keyword: '#{keyword}'"
          end
        end
      elsif current.name == 'ul'
        puts "  List of union members:"
        current.css('li').each do |li|
          link = li.css('a').first
          puts "    - #{link ? link.text : li.text.strip[0..50]}"
        end
      elsif current.name == 'table'
        puts "  *** Unexpected: Found table for union type!"
        headers = current.css('thead tr th').map(&:text)
        puts "      Headers: #{headers.inspect}"
      end

      current = current.next_element
    end

    puts "\nElements:"
    elements.each do |el|
      puts "  #{el[:name]}: #{el[:text][0..100]}"
    end
  else
    puts "NOT FOUND in HTML"
  end

  puts "\n"
end
