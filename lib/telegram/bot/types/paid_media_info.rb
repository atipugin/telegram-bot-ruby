# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaInfo < Base
        attribute :star_count, Types::Integer
        attribute :paid_media, Types::Array.of(PaidMedia)
      end
    end
  end
end
