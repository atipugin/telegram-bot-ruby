# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeDefault < Base
        attribute :type, Types::String.default('default')
      end
    end
  end
end
