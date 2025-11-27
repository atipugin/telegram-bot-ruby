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

LOADER = Zeitwerk::Loader.new
LOADER.inflector = Zeitwerk::GemInflector.new(__FILE__)
LOADER.inflector.inflect('endpoints' => 'ENDPOINTS')
LOADER.push_dir("#{__dir__}/bot", namespace: Telegram::Bot)
LOADER.setup
LOADER.eager_load if ENV['EAGER_LOAD'] == 'true'
