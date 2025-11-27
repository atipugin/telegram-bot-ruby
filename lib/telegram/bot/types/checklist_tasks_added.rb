# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChecklistTasksAdded < Base
        attribute? :checklist_message, Message
        attribute :tasks, Types::Array.of(ChecklistTask)
      end
    end
  end
end
