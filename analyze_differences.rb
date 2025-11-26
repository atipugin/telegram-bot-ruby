#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

existing = JSON.parse(File.read('data/type_attributes.json'))
generated = JSON.parse(File.read('data/type_attributes_generated.json'))

puts "=" * 80
puts "ANALYSIS OF type_attributes.json vs GENERATED"
puts "=" * 80
puts "\nExisting types: #{existing.keys.size}"
puts "Generated types: #{generated.keys.size}"

# Find common types
common = existing.keys & generated.keys
puts "\nCommon types: #{common.size}"

# Types only in existing
only_existing = existing.keys - generated.keys
puts "\nTypes ONLY in existing (#{only_existing.size}):"
only_existing.group_by do |type|
  attrs = existing[type]
  if attrs.empty?
    :empty
  elsif attrs['type'].is_a?(Array)
    :union
  else
    :normal
  end
end.each do |category, types|
  puts "  #{category}: #{types.size}"
  puts "    #{types.first(10).join(', ')}"
end

# Types only in generated (new types from API)
only_generated = generated.keys - existing.keys
puts "\nTypes ONLY in generated [NEW in API] (#{only_generated.size}):"
puts "  #{only_generated.join(', ')}"

# Compare common types for differences
puts "\n" + "=" * 80
puts "COMPARING COMMON TYPES"
puts "=" * 80

differences = []
common.first(5).each do |type_name|
  e = existing[type_name]
  g = generated[type_name]

  # Normalize for comparison (same key order)
  e_normalized = JSON.parse(JSON.generate(e))
  g_normalized = JSON.parse(JSON.generate(g))

  if e_normalized != g_normalized
    differences << type_name
    puts "\nDifference in #{type_name}:"

    # Find specific differences
    all_fields = (e.keys + g.keys).uniq
    all_fields.each do |field|
      if e[field] != g[field]
        puts "  Field '#{field}':"
        puts "    Existing: #{e[field].inspect}"
        puts "    Generated: #{g[field].inspect}"
      end
    end
  end
end

if differences.empty?
  puts "\n✓ First 5 common types match perfectly!"
else
  puts "\nDifferences found in: #{differences.join(', ')}"
end
