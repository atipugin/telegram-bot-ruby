#!/usr/bin/env ruby
# frozen_string_literal: true

# Test script to verify float default value parsing

def test_numeric_default_parsing(description)
  result = nil

  if (match = description.match(/defaults to\s+(\d+\.?\d*)\b/i))
    value = match[1]
    result = value.include?('.') ? value.to_f : value.to_i
  end

  result
end

# Test cases
test_cases = [
  { desc: "Optional. Defaults to 0", expected: 0, type: Integer },
  { desc: "Optional. Defaults to 0.0", expected: 0.0, type: Float },
  { desc: "Optional. Defaults to 1", expected: 1, type: Integer },
  { desc: "Optional. Defaults to 1.5", expected: 1.5, type: Float },
  { desc: "Optional. Defaults to 100", expected: 100, type: Integer },
  { desc: "Optional. Defaults to 3.14", expected: 3.14, type: Float },
  { desc: "Optional. Defaults to 2.0", expected: 2.0, type: Float }
]

puts "Testing numeric default value parsing:"
puts "=" * 60

all_passed = true
test_cases.each do |test|
  result = test_numeric_default_parsing(test[:desc])
  passed = result == test[:expected] && result.is_a?(test[:type])

  status = passed ? "✓ PASS" : "✗ FAIL"
  puts "#{status}: '#{test[:desc]}'"
  puts "  Expected: #{test[:expected].inspect} (#{test[:type]})"
  puts "  Got:      #{result.inspect} (#{result.class})"
  puts ""

  all_passed = false unless passed
end

puts "=" * 60
puts all_passed ? "All tests passed! ✓" : "Some tests failed! ✗"
exit(all_passed ? 0 : 1)
