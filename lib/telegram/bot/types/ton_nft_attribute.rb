# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TonNftAttribute < Base
        attribute :trait_type, Types::String
        attribute :value, Types::String
      end
    end
  end
end
