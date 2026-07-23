# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Link < Base
        attribute :url, Types::String
      end
    end
  end
end
