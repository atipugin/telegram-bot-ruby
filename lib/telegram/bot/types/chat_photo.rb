# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatPhoto < Base
        attribute :small_file_id, Types::String
        attribute :small_file_unique_id, Types::String
        attribute :big_file_id, Types::String
        attribute :big_file_unique_id, Types::String
      end
    end
  end
end
