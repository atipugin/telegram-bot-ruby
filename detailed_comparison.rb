#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

existing = JSON.parse(File.read('data/type_attributes.json'))
generated = JSON.parse(File.read('data/type_attributes_generated.json'))

puts "=" * 80
puts "DETAILED COMPARISON - Field by Field"
puts "=" * 80
puts ""

# Get common types
common_types = (existing.keys & generated.keys).sort

# Find types that differ
differing_types = []

common_types.each do |type_name|
  ex = existing[type_name]
  gen = generated[type_name]

  # Quick check if they're the same
  if ex != gen
    differing_types << type_name
  end
end

puts "Types that differ: #{differing_types.size} out of #{common_types.size} common types"
puts ""

# Analyze first 10 differences in detail
differing_types.first(10).each do |type_name|
  puts "=" * 80
  puts "Type: #{type_name}"
  puts "=" * 80

  ex = existing[type_name]
  gen = generated[type_name]

  # Check if it's a union type
  if ex.is_a?(Hash) && ex['type'].is_a?(Array)
    puts "Union type:"
    puts "  Existing: #{ex['type'].inspect}"
    puts "  Generated: #{gen['type'].inspect}"
    next
  end

  # Check if it's an empty type
  if ex.is_a?(Hash) && ex.empty?
    puts "Empty type:"
    puts "  Existing: #{ex.inspect}"
    puts "  Generated: #{gen.inspect}"
    next
  end

  # Regular type - compare fields
  all_fields = (ex.keys + gen.keys).uniq.sort

  all_fields.each do |field_name|
    ex_field = ex[field_name]
    gen_field = gen[field_name]

    if ex_field != gen_field
      puts "\nField: #{field_name}"
      puts "  Existing: #{ex_field.inspect}"
      puts "  Generated: #{gen_field.inspect}"

      # Show specific differences
      if ex_field && gen_field
        ex_field.each do |key, val|
          if gen_field[key] != val
            puts "    [#{key}] existing=#{val.inspect} generated=#{gen_field[key].inspect}"
          end
        end
        gen_field.each do |key, val|
          unless ex_field.key?(key)
            puts "    [#{key}] (only in generated) = #{val.inspect}"
          end
        end
      end
    end
  end

  puts ""
end

# Check for key ordering issues
puts "\n" + "=" * 80
puts "Key Ordering Check (first differing type)"
puts "=" * 80

if differing_types.any?
  type_name = differing_types.first
  ex = existing[type_name]
  gen = generated[type_name]

  if ex.is_a?(Hash) && !ex['type'].is_a?(Array)
    puts "\nType: #{type_name}"
    puts "Existing field order: #{ex.keys.inspect}"
    puts "Generated field order: #{gen.keys.inspect}"
    puts "Same order? #{ex.keys == gen.keys}"
  end
end
