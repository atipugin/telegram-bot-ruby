# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButtonRequestChat < Base
        attribute :request_id, Types::Integer
        attribute :chat_is_channel, Types::Bool
        attribute? :chat_is_forum, Types::Bool
        attribute? :chat_has_username, Types::Bool
        attribute? :chat_is_created, Types::Bool
        attribute? :user_administrator_rights, ChatAdministratorRights
        attribute? :bot_administrator_rights, ChatAdministratorRights
        attribute? :bot_is_member, Types::Bool
        attribute? :request_title, Types::Bool
        attribute? :request_username, Types::Bool
        attribute? :request_photo, Types::Bool
      end
    end
  end
end
