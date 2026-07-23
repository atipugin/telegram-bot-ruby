# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockTable < Base
        attribute :type, Types::String.constrained(eql: 'table').default('table')
        attribute :cells, Types::Array.of(Types::Array.of(RichBlockTableCell))
        attribute? :is_bordered, Types::True
        attribute? :is_striped, Types::True
        attribute? :caption, RichText
      end
    end
  end
end
