# frozen_string_literal: true

require_relative 'telegram_api_parser'

desc 'Parse Telegram Bot API documentation and generate type_attributes.json'
task :parse_telegram do
  puts "=" * 80
  puts "Telegram Bot API Type Attributes Generator"
  puts "=" * 80
  puts ""

  parser = TelegramApiParser.new
  parser.fetch
  parser.parse
  parser.add_custom_types!

  output_file = ENV['OUTPUT'] || "#{__dir__}/../data/type_attributes.json"
  parser.save(output_file)

  puts ""
  puts "=" * 80
  puts "Summary:"
  puts "  Generated #{parser.instance_variable_get(:@types).size} types"
  puts "  File: #{output_file}"
  puts "=" * 80
end
