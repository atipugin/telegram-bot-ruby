# frozen_string_literal: true

require_relative 'docs_parsers/types_parser'
require_relative 'docs_parsers/methods_parser'

namespace :parse do
  desc 'Parse Telegram Bot API documentation and generate types.json'
  task :types do
    output_file = "#{__dir__}/../data/types.json"

    parser = DocsParsers::TypesParser.new
    parser.fetch
    parser.parse
    parser.add_custom_types!
    parser.save(output_file)

    puts '✓ Parsed types'
    puts "  Generated #{parser.instance_variable_get(:@types).size} types"
  end

  desc 'Parse Telegram Bot API documentation and generate endpoints.json'
  task :endpoints do
    output_file = "#{__dir__}/../data/endpoints.json"

    parser = DocsParsers::MethodsParser.new
    parser.fetch
    parser.parse
    parser.save(output_file)

    puts '✓ Parsed methods'
    puts "  Generated #{parser.instance_variable_get(:@methods).size} methods"
  end
end
