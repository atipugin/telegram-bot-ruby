# frozen_string_literal: true

module Telegram
  module Bot
    class Client
      attr_reader :api, :options
      attr_accessor :logger

      DEFAULT_THREADS_NUM = 10

      def self.run(*args, &block)
        new(*args).run(&block)
      end

      def initialize(token, hash = {})
        @options = default_options.merge(hash)
        @api = Api.new(token, url: options[:url], environment: options[:environment])
        @logger = options[:logger]
        @offset = 0
        @limit = options[:threads_num]
        @timeout = options[:timeout]
      end

      def run
        logger.info('Starting bot')
        @running = true
        yield self
      end

      def listen(&block)
        loop do
          break unless @running

          begin
            threads = fetch_updates(&block)
            threads.map(&:join)
          rescue Faraday::TimeoutError, Faraday::ConnectionFailed
            # :no-op:
          end
        end
      end

      def stop
        @running = false
      end

      def fetch_updates(&block)
        [].tap do |threads|
          api.getUpdates(params).each do |update|
            threads << Thread.new { block.call(handle_update(update)) }
          end
        end
      end

      def handle_update(update)
        @offset = update.update_id.next
        message = update.current_message
        log_incoming_message(message)

        message
      end

      private

      def params
        {
          limit: @limit,
          offset: @offset,
          timeout: @timeout
        }
      end

      def default_options
        {
          threads_num: DEFAULT_THREADS_NUM,
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
