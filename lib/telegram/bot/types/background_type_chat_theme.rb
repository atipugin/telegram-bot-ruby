# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundTypeChatTheme < Base
        attribute :type, Types::String.constrained(eql: 'chat_theme').default('chat_theme')
        attribute :theme_name, Types::String
      end
    end
  end
end
