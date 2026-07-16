# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class AffiliateInfo < Base
        attribute? :affiliate_user, User
        attribute? :affiliate_chat, Chat
        attribute :commission_per_mille, Types::Integer
        attribute :amount, Types::Integer
        attribute? :nanostar_amount, Types::Integer
      end
    end
  end
end
