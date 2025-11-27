# frozen_string_literal: true

require 'dotenv/load'

ENV['BOT_API_ENV'] ||= 'test'
ENV['BOT_API_TOKEN'] ||= 'test_api_token'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/cassettes"
  config.default_cassette_options = { record_on_error: false }
  config.hook_into :faraday
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<BOT_API_TOKEN>') do
    ENV.fetch('BOT_API_TOKEN')
  end
end

require_relative '../lib/telegram/bot'

Telegram::Bot::LOADER.eager_load
