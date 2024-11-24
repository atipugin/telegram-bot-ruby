# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Birthdate < Base
        attribute :day, Types::Integer
        attribute :month, Types::Integer
        attribute? :year, Types::Integer
      end
    end
  end
end
