# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChecklistTask < Base
        attribute :id, Types::Integer
        attribute :text, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
        attribute? :completed_by_user, User
        attribute? :completion_date, Types::Integer
      end
    end
  end
end
