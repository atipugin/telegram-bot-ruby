# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Checklist < Base
        attribute :title, Types::String
        attribute? :title_entities, Types::Array.of(MessageEntity)
        attribute :tasks, Types::Array.of(ChecklistTask)
        attribute? :others_can_add_tasks, Types::True
        attribute? :others_can_mark_tasks_as_done, Types::True
      end
    end
  end
end
