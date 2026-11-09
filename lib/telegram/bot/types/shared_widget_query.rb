# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SharedWidgetQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute :type, WidgetQueryType
        attribute :data, Types::String
        attribute :widget_id, Types::String
      end
    end
  end
end
