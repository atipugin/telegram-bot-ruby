# frozen_string_literal: true

require 'json'
require_relative 'docs'
require_relative 'parsers/types_parser'
require_relative 'parsers/methods_parser'

namespace :parse do
  desc 'Download the Telegram Bot API documentation into tmp/'
  task :fetch do
    source = Docs::Source.new
    source.download
    puts "Downloaded #{source.url} to #{source.cache_path}"
  end

  desc 'Parse types from Telegram Bot API HTML documentation'
  task :types do
    puts 'Parsing types from Telegram Bot API...'

    result = Parsers::TypesParser.new.parse

    puts "Found #{result.keys.count} types"

    File.write "#{__dir__}/../data/types.json", JSON.pretty_generate(result)
    puts 'Written to data/types.json'
  end

  desc 'Parse methods from Telegram Bot API HTML documentation'
  task :methods do
    puts 'Parsing methods from Telegram Bot API...'

    parser = Parsers::MethodsParser.new
    result = parser.parse

    puts "Found #{result.keys.count} methods"

    File.write "#{__dir__}/../data/methods.json", JSON.pretty_generate(result)
    puts 'Written to data/methods.json'

    # A method the parser cannot read is a parser bug, not a missing endpoint.
    abort "Unmatched return types: #{parser.unmatched.join(', ')}" if parser.unmatched.any?
  end

  desc 'Refresh the documentation, then parse types and methods'
  task all: %i[fetch types methods]
end
