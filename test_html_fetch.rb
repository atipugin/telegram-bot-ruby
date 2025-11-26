#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'nokogiri'

url = URI('https://core.telegram.org/bots/api')
response = Net::HTTP.get_response(url)

if response.is_a?(Net::HTTPSuccess)
  doc = Nokogiri::HTML(response.body)

  # Debug: Check overall structure
  puts "Total h3: #{doc.css('h3').size}"
  puts "Total h4: #{doc.css('h4').size}"
  puts "Total tables: #{doc.css('table').size}"
  puts ""

  # Look for tables and see what's near them
  puts "=" * 80
  puts "Analyzing first 3 tables and their context:"
  puts "=" * 80
  doc.css('table').first(3).each_with_index do |table, i|
    puts "\nTable #{i + 1}:"

    # Find nearest preceding header
    prev_h4 = table.xpath('preceding::h4[1]').first
    prev_h3 = table.xpath('preceding::h3[1]').first

    puts "  Preceding h4: #{prev_h4&.text&.strip} (id: #{prev_h4&.[]('id')})" if prev_h4
    puts "  Preceding h3: #{prev_h3&.text&.strip} (id: #{prev_h3&.[]('id')})" if prev_h3

    # Show table headers
    headers = table.css('thead tr th, tr:first-child th').map(&:text)
    puts "  Headers: #{headers.inspect}"

    # Show first row
    first_row = table.css('tbody tr:first-child, tr:nth-child(2)').first
    if first_row
      cells = first_row.css('td').map { |td| td.text.strip[0..40] }
      puts "  First row: #{cells.inspect}"
    end
  end

  # Try to find patterns - look for "Update" type specifically
  puts "\n" + "=" * 80
  puts "Looking for 'Update' type definition:"
  puts "=" * 80

  update_headers = doc.search("*[text()*='Update']").select { |el| el.name =~ /h[34]/ }
  puts "Found #{update_headers.size} headers mentioning 'Update'"

  update_headers.first(3).each do |header|
    puts "\nHeader: #{header.name} - #{header.text.strip}"
    puts "ID: #{header['id']}"

    # Look for nearby tables
    5.times do
      header = header.next_element
      break unless header

      if header.name == 'table'
        puts "FOUND TABLE!"
        headers = header.css('thead tr th, tr:first-child th').map(&:text)
        puts "Headers: #{headers.inspect}"
        break
      end
    end
  end

else
  puts "Failed to fetch: #{response.code} #{response.message}"
end
