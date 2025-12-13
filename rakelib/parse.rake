# frozen_string_literal: true

require 'json'
require_relative 'parsers/types_parser'
require_relative 'parsers/methods_parser'

namespace :parse do
  desc 'Parse types from Telegram Bot API HTML documentation'
  task :types do
    puts 'Parsing types from Telegram Bot API...'

    result = Parsers::TypesParser.new.parse

    puts "Found #{result.keys.count} types"

    File.write "#{__dir__}/../data/type_attributes.json", JSON.pretty_generate(result)
    puts 'Written to data/type_attributes.json'
  end

  desc 'Parse methods from Telegram Bot API HTML documentation'
  task :methods do
    puts 'Parsing methods from Telegram Bot API...'

    result = Parsers::MethodsParser.new.parse

    puts "Found #{result.keys.count} methods"

    File.write "#{__dir__}/../data/method_return_types.json", JSON.pretty_generate(result)
    puts 'Written to data/method_return_types.json'
  end
end
