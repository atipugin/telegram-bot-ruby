# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WriteAccessAllowed < Base
        attribute? :web_app_name, Types::String
      end
    end
  end
end
