# frozen_string_literal: true

require_relative 'docs_parsers/types_parser'
require_relative 'docs_parsers/methods_parser'

namespace :parse do
  desc 'Parse Telegram Bot API documentation and generate type_attributes.json'
  task :types do
    puts '=' * 80
    puts 'Telegram Bot API Type Attributes Generator'
    puts '=' * 80
    puts ''

    parser = DocsParsers::TypesParser.new
    parser.fetch
    parser.parse
    parser.add_custom_types!

    output_file = ENV['OUTPUT'] || "#{__dir__}/../data/type_attributes.json"
    parser.save(output_file)

    puts ''
    puts '=' * 80
    puts 'Summary:'
    puts "  Generated #{parser.instance_variable_get(:@types).size} types"
    puts "  File: #{output_file}"
    puts '=' * 80
  end

  desc 'Parse Telegram Bot API documentation and generate methods.json'
  task :methods do
    puts '=' * 80
    puts 'Telegram Bot API Methods Generator'
    puts '=' * 80
    puts ''

    parser = DocsParsers::MethodsParser.new
    parser.fetch
    parser.parse

    output_file = ENV['OUTPUT'] || "#{__dir__}/../data/methods.json"
    parser.save(output_file)

    puts ''
    puts '=' * 80
    puts 'Summary:'
    puts "  Generated #{parser.instance_variable_get(:@methods).size} methods"
    puts "  File: #{output_file}"
    puts '=' * 80
  end
end
