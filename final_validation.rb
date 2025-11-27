#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

existing = JSON.parse(File.read('data/type_attributes.json'))
generated = JSON.parse(File.read('data/type_attributes_generated.json'))

puts 'Final Validation:'
puts '=' * 80
puts ''

# Check a few critical types
critical_types = [
  ['BackgroundFillSolid', 'type', 'solid'],
  ['MessageOriginUser', 'type', 'user'],
  ['ChatMemberOwner', 'status', 'creator'],
  ['PassportElementErrorDataField', 'source', 'data'],
  ['RefundedPayment', 'currency', 'XTR']
]

all_good = true
critical_types.each do |type, field, expected|
  gen_val = generated.dig(type, field, 'required_value')
  if gen_val == expected
    puts "OK: #{type}.#{field} = \"#{expected}\""
  else
    puts "FAIL: #{type}.#{field} - expected \"#{expected}\", got #{gen_val.inspect}"
    all_good = false
  end
end

puts ''
if all_good
  puts 'All critical fields validated successfully!'
else
  puts 'Some fields failed validation'
  exit 1
end
