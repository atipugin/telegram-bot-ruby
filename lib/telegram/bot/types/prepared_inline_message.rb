# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PreparedInlineMessage < Base
        attribute :id, Types::String
        attribute :expiration_date, Types::Integer
      end
    end
  end
end
