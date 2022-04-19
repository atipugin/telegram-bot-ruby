# frozen_string_literal: true

module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter, :open_timeout, :timeout

      def initialize
        @adapter = Faraday.default_adapter
        @open_timeout = 20
        @timeout = 20
      end
    end
  end
end
