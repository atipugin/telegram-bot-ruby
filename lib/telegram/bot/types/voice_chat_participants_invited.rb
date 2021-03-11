module Telegram
  module Bot
    module Types
      class VoiceChatParticipantsInvited < Base
        attribute :users, Array[User]
      end
    end
  end
end
