# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WriteAccessAllowed < Base
        attribute? :from_request, Types::Bool
        attribute? :web_app_name, Types::String
        attribute? :from_attachment_menu, Types::Bool
      end
    end
  end
end
