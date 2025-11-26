#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

# Check empty types
['ForumTopicClosed', 'ForumTopicReopened', 'GeneralForumTopicHidden', 'CallbackGame'].each do |type_name|
  puts "=" * 80
  puts "Looking for: #{type_name}"
  puts "=" * 80

  header = doc.css('h4').find { |h| h.text.strip == type_name }

  if header
    puts "Found header!"

    current = header.next_element
    count = 0

    while current && current.name != 'h4' && count < 5
      puts "  Element: #{current.name}"

      if current.name == 'p'
        puts "    Text: #{current.text.strip[0..150]}"
      elsif current.name == 'table'
        puts "    *** HAS TABLE! ***"
        headers = current.css('thead tr th').map(&:text)
        puts "    Headers: #{headers.inspect}"

        rows = current.css('tbody tr, tr').size
        puts "    Rows: #{rows}"

        if rows == 0 || (rows == 1 && current.css('thead').size > 0)
          puts "    -> Empty table (header only)"
        end
      end

      current = current.next_element
      count += 1
    end
  else
    puts "NOT FOUND"
  end

  puts "\n"
end
