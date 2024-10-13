# frozen_string_literal: true

module Telegram
  module Bot
    class Client
      attr_reader :api, :options
      attr_accessor :logger

      def self.run(*args, &block)
        new(*args).run(&block)
      end

      def initialize(token, hash = {})
        @options = default_options.merge(hash)
        @api = Api.new(token, url: options.delete(:url), environment: options.delete(:environment))
        @logger = options.delete(:logger)
      end

      def run
        yield self
      end

      def listen(&block)
        logger.info('Starting bot')
        @running = true
        fetch_updates(&block) while @running
      end

      def stop
        @running = false
      end

      def fetch_updates
        api.getUpdates(options).each do |update|
          yield handle_update(update)
        end
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed
        retry if @running
      end

      def handle_update(update)
        @options[:offset] = update.update_id.next
        message = update.current_message
        log_incoming_message(message)

        message
      end

      private

      def default_options
        {
          offset: 0,
          timeout: 20,
          logger: NullLogger.new,
          url: 'https://api.telegram.org',
          environment: :production
        }
      end

      def log_incoming_message(message)
        uid = message.respond_to?(:from) && message.from ? message.from.id : nil
        logger.info(
          format('Incoming message: text="%<message>s" uid=%<uid>s', message: message, uid: uid)
        )
      end
    end
  end
end
