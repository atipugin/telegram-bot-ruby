# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class VideoChatParticipantsInvited < Base
        attribute :users, Array[User]
      end
    end
  end
end
