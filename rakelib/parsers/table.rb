# frozen_string_literal: true

require_relative 'page_object'

module Parsers
  class Table < PageObject
    texts :headers, 'th'
    elements :rows, '> tbody > tr'

    def expect_headers(expected)
      raise Error, "has unexpected table headers #{headers.inspect}" if headers != expected
    end
  end
end
