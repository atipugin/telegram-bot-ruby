# frozen_string_literal: true

require 'logger'
require 'json'
require 'faraday'
require 'faraday/multipart'
require 'dry-struct'

require_relative 'bot/types'
require_relative 'bot/configuration'
require_relative 'bot/client'

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
