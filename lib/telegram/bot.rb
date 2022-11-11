# frozen_string_literal: true

require 'virtus'
require 'logger'
require 'json'
require 'faraday'
require 'faraday/multipart'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/bot", namespace: Telegram::Bot)
loader.setup

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
