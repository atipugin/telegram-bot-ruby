#!/usr/bin/env ruby
# frozen_string_literal: true

description = "Optional. True, if the user is allowed to create forum topics. If omitted defaults to the value of can_pin_messages"

puts "Description:"
puts description
puts ""

# Test the regex
if (match = description.match(/defaults to\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
  puts "Matched quoted pattern: '#{match[1]}'"
elsif (match = description.match(/defaults to\s+(\w+)(?!\s+value)/i))
  puts "Matched unquoted pattern: '#{match[1]}'"
  puts "Full match: '#{match[0]}'"
else
  puts "No match"
end

puts ""
puts "Testing different patterns:"

# Pattern 1 - Quoted
if (match = description.match(/defaults to\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
  puts "1. Quoted: #{match[1].inspect}"
end

# Pattern 2 - Boolean
if (match = description.match(/defaults to\s+(true|false)\b/i))
  puts "2. Boolean: #{match[1].inspect}"
end

# Pattern 3 - Numeric
if (match = description.match(/defaults to\s+(\d+\.?\d*)\b/i))
  value = match[1]
  result = value.include?('.') ? value.to_f : value.to_i
  puts "3. Numeric: #{match[1].inspect} -> #{result.inspect}"
end

if !description.match(/defaults to\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i) &&
   !description.match(/defaults to\s+(true|false)\b/i) &&
   !description.match(/defaults to\s+(\d+\.?\d*)\b/i)
  puts "NO MATCH (correctly skipping field reference)"
end

# Find all "defaults to" occurrences
puts ""
puts "All 'defaults to' patterns:"
description.scan(/defaults to\s+\S+\s*\S*/i) do |match|
  puts "  - #{match.inspect}"
end
