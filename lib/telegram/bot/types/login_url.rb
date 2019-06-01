module Telegram
  module Bot
    module Types
      class LoginUrl < Base
        attribute :url, String
        attribute :forward_text, String
        attribute :bot_username, String
        attribute :request_write_access, Boolean
      end
    end
  end
end
