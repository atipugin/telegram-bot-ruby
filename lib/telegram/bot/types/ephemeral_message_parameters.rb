# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class EphemeralMessageParameters < Base
        attribute :receiver_user_id, Types::Integer
        attribute? :callback_query_id, Types::String
        attribute? :replace_callback_query_message, Types::Bool
      end
    end
  end
end
