require 'virtus'
require 'inflecto'
require 'logger'
require 'json'
require 'faraday'

require 'telegram/bot/types'
require 'telegram/bot/exceptions'
require 'telegram/bot/api'
require 'telegram/bot/null_logger'
require 'telegram/bot/client'
require 'telegram/bot/version'
require 'telegram/bot/configuration'

module Telegram
  module Bot
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
