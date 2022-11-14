# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollOption < Base
        attribute :text, Types::String
        attribute :voter_count, Types::Integer
      end
    end
  end
end
