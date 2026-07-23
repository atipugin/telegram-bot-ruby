# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Community < Base
        attribute :id, Types::Integer
        attribute :name, Types::String
      end
    end
  end
end
