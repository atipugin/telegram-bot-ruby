# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForceReply < Base
        attribute :force_reply, Boolean
        attribute :input_field_placeholder, String
        attribute :selective, Boolean, default: false
      end
    end
  end
end
