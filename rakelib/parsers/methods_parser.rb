# frozen_string_literal: true

require_relative '../docs'
require_relative 'return_type_rules'

module Parsers
  # Builds data/methods.json: the return type of every documented method.
  class MethodsParser
    # Methods are camelCase; types on the same heading level are CapitalCase.
    NAME = /\A[a-z][a-zA-Z0-9]*\z/.freeze

    attr_reader :unmatched

    def initialize(page: nil)
      @page = page || Docs::Page.load
      @unmatched = []
    end

    def parse
      @unmatched = []

      @page.sections.each_with_object({}) do |section, result|
        next unless section.title.match?(NAME)

        type = return_type(section)
        type ? result[section.title] = type : record_miss(section.title)
      end
    end

    private

    # A miss used to be indistinguishable from "absent from the docs", which
    # is how getChatMemberCount went missing from ENDPOINTS.
    def record_miss(name)
      @unmatched << name
      warn "WARNING: no return type matched for #{name}"
    end

    def return_type(section)
      section.paragraphs.each do |paragraph|
        matched = ReturnTypeRules.match(paragraph)
        return matched.last if matched
      end
      nil
    end
  end
end
