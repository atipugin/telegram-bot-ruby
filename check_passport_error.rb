#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

type_name = 'PassportElementErrorDataField'
header = doc.css('h4').find { |h| h.text.strip == type_name }

if header
  current = header.next_element
  while current && current.name != 'h4'
    if current.name == 'table'
      current.css('tbody tr, tr').each do |row|
        cells = row.css('td')
        next if cells.size < 3

        field_name = cells[0].text.strip
        next unless field_name == 'source'

        description = cells[2].text.strip
        puts "Field: #{field_name}"
        puts "Description: #{description.inspect}"

        # Test patterns
        if (match = description.match(/always\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
          puts "Matched 'always' with quotes: '#{match[1]}'"
        elsif (match = description.match(/always\s+(\w+)/i))
          puts "Matched 'always' without quotes: '#{match[1]}'"
        elsif (match = description.match(/must be\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
          puts "Matched 'must be' with quotes: '#{match[1]}'"
        elsif (match = description.match(/must be\s+(\w+)/i))
          puts "Matched 'must be' without quotes: '#{match[1]}'"
        else
          puts "NO MATCH"
        end
      end
      break
    end
    current = current.next_element
  end
end
