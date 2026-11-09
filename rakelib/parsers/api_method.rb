# frozen_string_literal: true

require_relative 'entry'
require_relative 'table'
require_relative 'return_type'

module Parsers
  class ApiMethod < Entry
    TABLE_HEADERS = %w[Parameter Type Required Description].freeze

    blocks :paragraphs, 'p'
    block :table, 'table', as: Table

    def return_type
      @return_type ||= ReturnType.parse(paragraphs.map(&:inner_html))
    end

    private

    def validate!
      raise Error, 'cannot find the return type' unless return_type

      table&.expect_headers(TABLE_HEADERS)
    end
  end
end
