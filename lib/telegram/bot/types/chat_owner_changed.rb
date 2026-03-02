# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatOwnerChanged < Base
        attribute :new_owner, User
      end
    end
  end
end
