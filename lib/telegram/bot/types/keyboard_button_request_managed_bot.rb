# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButtonRequestManagedBot < Base
        attribute :request_id, Types::Integer
        attribute? :suggested_name, Types::String
        attribute? :suggested_username, Types::String
      end
    end
  end
end
