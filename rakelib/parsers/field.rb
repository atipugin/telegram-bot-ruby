# frozen_string_literal: true

require_relative 'page_object'
require_relative 'type_ref'
require_relative 'description'

module Parsers
  class Field < PageObject
    cell :name, 0
    cell :type_text, 1
    cell :description, 2, as: Description

    def type
      @type ||= TypeRef.new(type_text)
    end

    def required?
      !description.optional?
    end

    private

    # Reads the cells now, so that a bad row fails along with its entry instead
    # of whenever it is first used.
    def validate!
      type
      description
    end
  end
end
