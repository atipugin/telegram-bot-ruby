# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForceReply < Base
        attribute :force_reply, Types::True
        attribute? :input_field_placeholder, Types::String.constrained(min_size: 1, max_size: 64)
        attribute? :selective, Types::Bool
      end
    end
  end
end
