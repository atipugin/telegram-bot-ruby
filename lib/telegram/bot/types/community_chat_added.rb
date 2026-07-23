# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class CommunityChatAdded < Base
        attribute :community, Community
      end
    end
  end
end
