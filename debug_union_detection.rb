#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)
doc = Nokogiri::HTML(response.body)

UNION_KEYWORDS = [
  /can be one of/i,
  /it can be one of/i,
  /should be one of/i,
  /represents one of/i,
  /currently,? the following \d+/i,
  /currently support(s|ed)? (results of the |the )?following \d+/i,
  /This object describes.*(it can be|one of)/i
].freeze

type_name = 'InputMessageContent'
header = doc.css('h4').find { |h| h.text.strip == type_name }

puts "Checking: #{type_name}"

# Get description
current = header.next_element
descriptions = []

while current && current.name != 'h4' && current.name != 'h3'
  break if current.name == 'table' || current.name == 'ul'

  descriptions << current.text.strip if current.name == 'p'
  current = current.next_element
end

description = descriptions.join(' ')

puts "Description: #{description}"
puts ""

# Test each pattern
UNION_KEYWORDS.each_with_index do |pattern, i|
  match = description.match?(pattern)
  puts "Pattern #{i + 1} (#{pattern}): #{match ? 'MATCH' : 'no match'}"
end

puts ""

# Check if it has a list
list = nil
current = header.next_element
count = 0
while current && current.name != 'h4' && current.name != 'h3' && count < 5
  if current.name == 'ul'
    list = current
    break
  end
  current = current.next_element
  count += 1
end

puts "Has UL list: #{!list.nil?}"

# Check if it has a table
table = nil
current = header.next_element
while current && current.name != 'h4' && current.name != 'h3'
  if current.name == 'table'
    table = current
    break
  end
  current = current.next_element
end

puts "Has table: #{!table.nil?}"
