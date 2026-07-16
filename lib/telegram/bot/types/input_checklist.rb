# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputChecklist < Base
        attribute :title, Types::String.constrained(min_size: 1, max_size: 255)
        attribute? :parse_mode, Types::String
        attribute? :title_entities, Types::Array.of(MessageEntity)
        attribute :tasks, Types::Array.of(InputChecklistTask)
        attribute? :others_can_add_tasks, Types::Bool
        attribute? :others_can_mark_tasks_as_done, Types::Bool
      end
    end
  end
end
