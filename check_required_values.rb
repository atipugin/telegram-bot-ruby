#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

generated = JSON.parse(File.read('data/type_attributes_test.json'))

puts 'BackgroundFillSolid.type:'
puts JSON.pretty_generate(generated['BackgroundFillSolid']['type'])
puts ''

# Check a few more
['MessageOriginUser', 'ChatMemberOwner', 'PassportElementErrorDataField'].each do |type|
  if generated[type]
    field = generated[type]['type'] || generated[type]['status'] || generated[type]['source']
    if field
      puts "#{type}:"
      puts "  Has required_value: #{field['required_value'] != nil}"
      puts "  Value: '#{field['required_value']}'" if field['required_value']
      puts "  Default: '#{field['default']}'" if field['default']
    end
  end
end
