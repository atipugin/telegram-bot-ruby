# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Gifts < Base
        attribute :gifts, Types::Array.of(Gift)
      end
    end
  end
end
