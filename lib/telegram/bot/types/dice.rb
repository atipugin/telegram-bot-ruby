# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Dice < Base
        attribute :emoji, String
        attribute :value, Integer
      end
    end
  end
end
