# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForceReply < Base
        attribute :force_reply, Types::True
        attribute? :input_field_placeholder, Types::String
        attribute? :selective, Types::Bool.default(false)
      end
    end
  end
end
