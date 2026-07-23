# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockListItem < Base
        attribute :blocks, Types::Array.of(Types.deferred(:InputRichBlock))
        attribute? :has_checkbox, Types::True
        attribute? :is_checked, Types::True
        attribute? :value, Types::Integer
        attribute? :type, Types::String
      end
    end
  end
end
