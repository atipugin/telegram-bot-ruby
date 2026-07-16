# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class DirectMessagesTopic < Base
        attribute :topic_id, Types::Integer
        attribute? :user, User
      end
    end
  end
end
