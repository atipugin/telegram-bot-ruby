# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichMessage < Base
        attribute :blocks, Types::Array.of(RichBlock)
        attribute? :is_rtl, Types::Bool
      end
    end
  end
end
