# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class User < Base
        attribute :id, Types::Integer
        attribute :is_bot, Types::Bool
        attribute :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :username, Types::String
        attribute? :language_code, Types::String
        attribute? :is_premium, Types::True
        attribute? :added_to_attachment_menu, Types::True
        attribute? :can_join_groups, Types::Bool
        attribute? :can_read_all_group_messages, Types::Bool
        attribute? :supports_inline_queries, Types::Bool
        attribute? :can_connect_to_business, Types::Bool
        attribute? :has_main_web_app, Types::Bool
      end
    end
  end
end
