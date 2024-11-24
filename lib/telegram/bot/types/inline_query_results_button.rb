# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultsButton < Base
        attribute :text, Types::String
        attribute? :web_app, WebAppInfo
        attribute? :start_parameter, Types::String.constrained(min_size: 1, max_size: 64)
      end
    end
  end
end
