# frozen_string_literal: true

require 'logger'
require 'json'
require 'faraday'
require 'faraday/multipart'
require 'zeitwerk'
require 'dry-struct'

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

loader = Zeitwerk::Loader.new
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect('endpoints' => 'ENDPOINTS')
loader.push_dir("#{__dir__}/bot", namespace: Telegram::Bot)
loader.setup
