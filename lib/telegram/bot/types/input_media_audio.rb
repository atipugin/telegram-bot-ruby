module Telegram
  module Bot
    module Types
      class InputMediaAudio < Base
        attribute :type, String, default: 'audio'
        attribute :media, String
        attribute :thumb, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :duration, Integer
        attribute :performer, String
        attribute :title, String
      end
    end
  end
end
