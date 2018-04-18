require 'faraday/adapter/net_http'
module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter, :proxy_opts, :ssl_opts

      def initialize
        @adapter = Faraday.default_adapter
      end
    end
  end
end
