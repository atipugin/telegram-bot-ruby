#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

type_name = 'BackgroundFillSolid'
header = doc.css('h4').find { |h| h.text.strip == type_name }

puts "=" * 80
puts "Checking: #{type_name}"
puts "=" * 80

if header
  # Find table
  current = header.next_element
  while current && current.name != 'h4'
    if current.name == 'table'
      puts "\nTable found!"

      # Get all rows
      current.css('tbody tr, tr').each_with_index do |row, i|
        cells = row.css('td')
        next if cells.size < 3

        field_name = cells[0].text.strip
        next if field_name == 'Field' # header

        type_text = cells[1].text.strip
        description = cells[2].text.strip

        puts "\nRow #{i}:"
        puts "  Field: #{field_name}"
        puts "  Type: #{type_text}"
        puts "  Description: #{description}"

        # Check for patterns
        if description.match?(/must be/i)
          puts "  *** HAS 'must be' PATTERN ***"
          if (match = description.match(/must be (.+?)(?:\.|,|$)/i))
            puts "  *** Extracted value: '#{match[1]}'"
          end
        end
      end

      break
    end
    current = current.next_element
  end
else
  puts "NOT FOUND"
end
