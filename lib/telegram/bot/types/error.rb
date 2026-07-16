# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Error < Base
        attribute :ok, Types::Bool
        attribute :error_code, Types::Integer
        attribute :description, Types::String
        attribute? :parameters, ResponseParameters
      end
    end
  end
end
