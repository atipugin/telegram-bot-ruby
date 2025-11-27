# frozen_string_literal: true

require 'json'
require_relative 'docs_parsers/types_parser'
require_relative 'docs_parsers/methods_parser'

namespace :parse do
  desc 'Parse Telegram Bot API documentation and generate types.json'
  task :types do
    output_file = "#{__dir__}/../data/types.json"

    parser = DocsParsers::TypesParser.new
    types = parser.parse

    File.write(output_file, JSON.pretty_generate(types))
    puts "\n✓ Saved to #{output_file}"
    puts "  Generated #{types.size} types"
  end

  desc 'Parse Telegram Bot API documentation and generate endpoints.json'
  task :endpoints do
    output_file = "#{__dir__}/../data/endpoints.json"

    parser = DocsParsers::MethodsParser.new
    methods = parser.parse

    File.write(output_file, JSON.pretty_generate(methods))
    puts "\n✓ Saved to #{output_file}"
    puts "  Generated #{methods.size} methods"
  end
end
