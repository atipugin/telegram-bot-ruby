# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class CommunityChatJoined < Base
        attribute :community, Community
      end
    end
  end
end
