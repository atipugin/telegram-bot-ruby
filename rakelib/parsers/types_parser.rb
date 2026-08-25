# frozen_string_literal: true

require_relative '../docs'
require_relative 'attribute_parser'

module Parsers
  # Builds data/types.json from the "Available types" sections of the docs.
  class TypesParser
    # Types are CapitalCase; methods on the same heading level are camelCase.
    NAME = /\A[A-Z][a-zA-Z0-9]*\z/.freeze
    FIELD_COLUMNS = %w[Field Type Description].freeze
    PLAIN_TEXT = /String for plain text/i.freeze

    def initialize(page: nil)
      @page = page || Docs::Page.load
    end

    def parse
      @page.sections.each_with_object({}) do |section, result|
        next unless section.title.match?(NAME)

        result[section.title] = parse_section(section)
      end
    end

    private

    def parse_section(section)
      return fields(section.table) if section.table

      variants = section.items.flat_map(&:links)
      return union(section, variants) if variants.any?

      # A handful of types legitimately hold no information.
      {}
    end

    def fields(table)
      table.expect_columns!(FIELD_COLUMNS)
      table.each_with_object({}) do |row, attributes|
        attributes[row['Field'].to_s] = AttributeParser.new(row).to_h
      end
    end

    # Union types list their members; the prose adds any non-struct members.
    def union(section, variants)
      { 'type' => (implied(section) + variants).uniq }
    end

    def implied(section)
      description = section.intro
      return [] unless description

      types = []
      types << 'string' if description.match?(PLAIN_TEXT)
      types << "array:#{section.title}" if description.match?(/an Array of #{Regexp.escape(section.title)}/i)
      types
    end
  end
end
