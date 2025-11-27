#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

existing = JSON.parse(File.read('data/type_attributes.json'))
generated = JSON.parse(File.read('data/type_attributes_generated.json'))

# Count required_value fields
def count_required_values(data)
  count = 0
  missing = []

  data.each do |type_name, attrs|
    next unless attrs.is_a?(Hash)

    attrs.each do |field_name, field_attrs|
      next unless field_attrs.is_a?(Hash)

      if field_attrs['required_value']
        count += 1
      elsif ['type', 'source', 'status'].include?(field_name)
        # Check if this should have required_value (discriminator field)
        # Only count if it's in a type that looks like a union member
        pattern = /(Origin|Fill|Type|Member|Source|Error|Result|Media|Scope|Button|Content|Withdrawal|Partner|Gift)/
        if type_name.match?(pattern) && !field_attrs['type'].is_a?(Array)
          missing << "#{type_name}.#{field_name}"
        end
      end
    end
  end

  [count, missing]
end

existing_count, existing_missing = count_required_values(existing)
generated_count, generated_missing = count_required_values(generated)

puts "=" * 80
puts "Required Value Fields Comparison"
puts "=" * 80
puts ""
puts "Existing file: #{existing_count} fields with required_value"
puts "Generated file: #{generated_count} fields with required_value"
puts ""

# Find specific differences
puts "Comparing specific types..."
puts "=" * 80

test_types = [
  'BackgroundFillSolid',
  'MessageOriginUser',
  'ChatMemberOwner',
  'PassportElementErrorDataField',
  'ReactionTypeEmoji',
  'BotCommandScopeDefault'
]

test_types.each do |type|
  puts "\n#{type}:"

  if existing[type] && generated[type]
    # Find discriminator field
    disc_field = nil
    ['type', 'source', 'status'].each do |f|
      if existing[type][f] || generated[type][f]
        disc_field = f
        break
      end
    end

    if disc_field
      ex_val = existing[type][disc_field]&.dig('required_value')
      gen_val = generated[type][disc_field]&.dig('required_value')

      if ex_val == gen_val
        puts "  ✓ #{disc_field}: '#{ex_val}' (matches)"
      else
        puts "  ✗ #{disc_field}:"
        puts "    Existing: #{ex_val.inspect}"
        puts "    Generated: #{gen_val.inspect}"
      end
    end
  elsif !existing[type]
    puts "  (Not in existing - new type)"
  elsif !generated[type]
    puts "  (Not in generated - missing)"
  end
end

# Sample comparison
puts "\n" + "=" * 80
puts "Random sample of types with required_value in EXISTING:"
puts "=" * 80

existing.select { |_k, v| v.is_a?(Hash) }.each do |type_name, attrs|
  attrs.each do |field_name, field_attrs|
    next unless field_attrs.is_a?(Hash)
    next unless field_attrs['required_value']

    gen_field = generated.dig(type_name, field_name)
    if gen_field && gen_field['required_value'] == field_attrs['required_value']
      # Matches - skip
    elsif gen_field && gen_field['required_value']
      puts "MISMATCH: #{type_name}.#{field_name}"
      puts "  Existing: #{field_attrs['required_value']}"
      puts "  Generated: #{gen_field['required_value']}"
    else
      puts "MISSING: #{type_name}.#{field_name} (should be '#{field_attrs['required_value']}')"
    end
  end
end

puts "\n✓ Comparison complete"
