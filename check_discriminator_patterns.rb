#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

types_to_check = [
  'MessageOriginUser',
  'ChatMemberOwner',
  'BackgroundFillGradient',
  'ReactionTypeEmoji',
  'BotCommandScopeDefault',
  'PassportElementErrorDataField'
]

types_to_check.each do |type_name|
  header = doc.css('h4').find { |h| h.text.strip == type_name }
  next unless header

  puts "=" * 80
  puts type_name
  puts "=" * 80

  current = header.next_element
  while current && current.name != 'h4'
    if current.name == 'table'
      # Find the type or status or source field
      current.css('tbody tr, tr').each do |row|
        cells = row.css('td')
        next if cells.size < 3

        field_name = cells[0].text.strip
        next unless ['type', 'status', 'source'].include?(field_name)

        description = cells[2].text.strip
        puts "Field '#{field_name}':"
        puts "  Description: #{description}"
        puts ""
      end
      break
    end
    current = current.next_element
  end
end
