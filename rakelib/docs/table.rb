# frozen_string_literal: true

require_relative 'error'
require_relative 'text'

module Docs
  # A documentation table, addressed by column name rather than cell index.
  #
  # The page only ever uses two shapes -- "Field | Type | Description" and
  # "Parameter | Type | Required | Description" -- so declaring the expected
  # columns is cheap, and it turns a docs change from silently-wrong data
  # into a failed parse.
  class Table
    include Enumerable

    attr_reader :columns

    def initialize(node)
      @node = node
      @columns = node.css('th').map { |cell| cell.text.strip }.freeze
    end

    def expect_columns!(expected)
      return self if columns == expected

      raise Error, "expected columns #{expected.inspect}, the docs now have #{columns.inspect}"
    end

    # Yields each row as a Hash of column name => Docs::Text.
    def each
      @node.css('tbody tr').each do |row|
        cells = row.css('td')
        next if cells.empty?

        yield columns.zip(cells.map { |cell| Text.new(cell) }).to_h
      end
    end
  end
end
