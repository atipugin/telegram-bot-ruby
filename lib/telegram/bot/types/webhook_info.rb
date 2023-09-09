# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WebhookInfo < Base
        attribute :url, Types::String
        attribute :has_custom_certificate, Types::Bool
        attribute :pending_update_count, Types::Integer
        attribute? :ip_address, Types::String
        attribute? :last_error_date, Types::Integer
        attribute? :last_error_message, Types::String
        attribute? :last_synchronization_error_date, Types::Integer
        attribute? :max_connections, Types::Integer
        attribute? :allowed_updates, Types::Array.of(Types::String)
      end
    end
  end
end
