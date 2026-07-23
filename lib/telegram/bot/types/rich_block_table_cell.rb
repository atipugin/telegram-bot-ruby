# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockTableCell < Base
        attribute? :text, RichText
        attribute? :is_header, Types::True
        attribute? :colspan, Types::Integer
        attribute? :rowspan, Types::Integer
        attribute :align, Types::String
        attribute :valign, Types::String
      end
    end
  end
end
