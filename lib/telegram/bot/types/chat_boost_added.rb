# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostAdded < Base
        attribute :boost_count, Types::Integer
      end
    end
  end
end
