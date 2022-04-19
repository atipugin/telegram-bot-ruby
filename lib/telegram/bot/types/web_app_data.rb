# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WebAppData < Base
        attribute :data, String
        attribute :button_text, String
      end
    end
  end
end
