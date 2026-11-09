# frozen_string_literal: true

require_relative 'entry'
require_relative 'table'
require_relative 'field'

module Parsers
  # An object without a table is a real thing: it holds no information.
  class ObjectType < Entry
    TABLE_HEADERS = %w[Field Type Description].freeze

    block :table, 'table', as: Table

    def fields
      @fields ||= table ? table.rows.map { |row| Field.new(row) } : []
    end

    private

    def validate!
      if table
        table.expect_headers(TABLE_HEADERS)
        raise Error, 'has a table without rows' if fields.empty?
      elsif body.any? { |block| block.name != 'p' }
        raise Error, 'has no table and is not just paragraphs'
      end
    end
  end
end
