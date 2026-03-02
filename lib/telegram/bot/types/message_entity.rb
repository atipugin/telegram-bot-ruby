# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageEntity < Base
        attribute :type, Types::String
        attribute :offset, Types::Integer
        attribute :length, Types::Integer
        attribute? :url, Types::String
        attribute? :user, User
        attribute? :language, Types::String
        attribute? :custom_emoji_id, Types::String
        attribute? :unix_time, Types::Integer
        attribute? :date_time_format, Types::String
      end
    end
  end
end
