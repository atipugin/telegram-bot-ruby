# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UserProfileAudios < Base
        attribute :total_count, Types::Integer
        attribute :audios, Types::Array.of(Audio)
      end
    end
  end
end
