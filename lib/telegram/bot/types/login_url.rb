# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class LoginUrl < Base
        attribute :url, Types::String
        attribute? :forward_text, Types::String
        attribute? :bot_username, Types::String
        attribute? :request_write_access, Types::Bool
      end
    end
  end
end
