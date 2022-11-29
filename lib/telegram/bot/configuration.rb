# frozen_string_literal: true

module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter, :connection_open_timeout, :connection_timeout

      def initialize
        @adapter = Faraday.default_adapter
        @connection_open_timeout = 20
        @connection_timeout = 20
      end
    end
  end
end
