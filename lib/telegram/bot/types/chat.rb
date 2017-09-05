module Telegram
  module Bot
    module Types
      class Chat
        include Virtus.model(finalize: false)
        include Compactable

        attribute :id, Integer
        attribute :type, String
        attribute :title, String
        attribute :username, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :all_members_are_administrators, Boolean
        attribute :photo, ChatPhoto
        attribute :description, String
        attribute :invite_link, String
        attribute :pinned_message, 'Telegram::Bot::Types::Message'
      end
    end
  end
end
