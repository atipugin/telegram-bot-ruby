# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockListItem < Base
        attribute :label, Types::String
        attribute :blocks, Types::Array.of(Types.deferred(:RichBlock))
        attribute? :has_checkbox, Types::True
        attribute? :is_checked, Types::True
        attribute? :value, Types::Integer
        attribute? :type, Types::String
      end
    end
  end
end
