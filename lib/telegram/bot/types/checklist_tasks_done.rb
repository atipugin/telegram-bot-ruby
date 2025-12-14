# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChecklistTasksDone < Base
        attribute? :checklist_message, Message
        attribute? :marked_as_done_task_ids, Types::Array.of(Types::Integer)
        attribute? :marked_as_not_done_task_ids, Types::Array.of(Types::Integer)
      end
    end
  end
end
