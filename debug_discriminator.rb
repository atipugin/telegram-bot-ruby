#!/usr/bin/env ruby
# frozen_string_literal: true

description = 'Type of the background fill, always "solid"'
field_name = 'type'

puts "Description: #{description}"
puts "Field: #{field_name}"
puts ""

discriminator_fields = ['type', 'source', 'status']

if discriminator_fields.include?(field_name)
  puts "Field is a discriminator candidate"

  patterns = [
    [/always\s+["'](.+?)["']/i, 'always "X"'],
    [/always\s+(\w+)/i, 'always X'],
    [/must be\s+["'](.+?)["']/i, 'must be "X"'],
    [/must be\s+(\w+)/i, 'must be X']
  ]

  patterns.each do |(pattern, name)|
    if (match = description.match(pattern))
      puts "✓ Matched pattern: #{name}"
      puts "  Captured value: '#{match[1]}'"
    else
      puts "✗ No match: #{name}"
    end
  end
else
  puts "Field is NOT a discriminator candidate"
end
