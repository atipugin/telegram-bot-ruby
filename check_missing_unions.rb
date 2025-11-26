#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

# Check missing union types
['BotCommandScope', 'MenuButton', 'InputMedia', 'InlineQueryResult', 'InputMessageContent', 'PassportElementError'].each do |type_name|
  puts "=" * 80
  puts "Checking: #{type_name}"
  puts "=" * 80

  header = doc.css('h4').find { |h| h.text.strip == type_name }

  if header
    puts "Found header!"

    current = header.next_element
    count = 0

    while current && current.name != 'h4' && count < 10
      case current.name
      when 'p'
        text = current.text.strip
        puts "  P: #{text[0..150]}"
        if text.match?(/one of|can be/i)
          puts "    *** HAS UNION KEYWORDS ***"
        end
      when 'ul'
        puts "  UL: List found"
        current.css('li').first(3).each do |li|
          link = li.css('a').first
          puts "    - #{link ? link.text : li.text.strip[0..40]}"
        end
      when 'table'
        puts "  TABLE: Found (#{current.css('tbody tr').size} rows)"
      end

      current = current.next_element
      count += 1
    end
  else
    puts "NOT FOUND"
  end

  puts "\n"
end
