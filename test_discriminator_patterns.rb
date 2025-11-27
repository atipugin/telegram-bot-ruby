#!/usr/bin/env ruby
# frozen_string_literal: true

descriptions = [
  "Error source, must be data",  # Should match: "data"
  "Currency in which the post will be paid. Currently, must be one of \"XTR\" for Telegram Stars or \"TON\" for toncoins",  # Should NOT match
  "Scope type, must be default",  # Should match: "default"
  "Type of the background fill, always \"solid\"",  # Should match: "solid"
]

descriptions.each do |desc|
  puts "=" * 80
  puts "Description:"
  puts desc
  puts ""

  # Test the patterns (matching parser logic)
  if (match = desc.match(/always\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
    puts "Matched 'always \"X\"': '#{match[1]}'"
  elsif (match = desc.match(/must be\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
    puts "Matched 'must be \"X\"': '#{match[1]}'"
  elsif !desc.match?(/must be\s+one\s+of/i) && (match = desc.match(/must be\s+(\w+)\b/i))
    puts "Matched 'must be X': '#{match[1]}'"
  else
    puts "NO MATCH (correctly skipped)"
  end
  puts ""
end
