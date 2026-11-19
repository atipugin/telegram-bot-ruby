# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WidgetQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute? :chat, Chat
        attribute? :message_id, Types::Integer
        attribute? :inline_message_id, Types::String
        attribute :chat_instance, Types::String
        attribute? :chat_type, Types::String
        attribute :type, WidgetQueryType
        attribute :data, Types::String
        attribute? :widget_id, Types::String
      end
    end
  end
end
