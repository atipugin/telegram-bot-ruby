# frozen_string_literal: true

require 'json'
require_relative 'parsers/types_parser'

namespace :parse do
  desc 'Parse types from Telegram Bot API HTML documentation'
  task :types do
    puts 'Parsing types from Telegram Bot API...'

    result = Parsers::TypesParser.new.parse

    puts "Found #{result.keys.count} types"

    File.write "#{__dir__}/../data/type_attributes.json", JSON.pretty_generate(result)
    puts 'Written to data/type_attributes.json'
  end
end
