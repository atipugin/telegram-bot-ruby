# frozen_string_literal: true

require_relative 'entry'
require_relative 'page_object'
require_relative 'type_ref'

module Parsers
  class UnionType < Entry
    class MemberList < PageObject
      texts :names, '> li a'
    end

    blocks :paragraphs, 'p'
    block :list, 'ul', as: MemberList
    block :table, 'table'

    def members
      list.names
    end

    def accepts_string?
      summary.match?(/String for plain text/i)
    end

    def accepts_array_of_self?
      summary.match?(/an Array of #{name}/i)
    end

    private

    def summary
      paragraphs.first&.text.to_s
    end

    def validate!
      raise Error, 'has both a field table and a union list' if table
      return if members.any? && members.all?(TypeRef::NAME)

      raise Error, "has unexpected union members #{members.inspect}"
    end
  end
end
