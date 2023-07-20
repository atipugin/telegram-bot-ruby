# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MenuButtonWebApp < Base
        attribute :type, Types::String.constrained(eql: 'web_app').default('web_app')
        attribute :text, Types::String
        attribute :web_app, WebAppInfo
      end
    end
  end
end
