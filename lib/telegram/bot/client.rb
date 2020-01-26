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
        @api = Api.new(token, url: options.delete(:url))
        @logger = options.delete(:logger)
      end

      def run
        yield self
      end

      def listen(&block)
        logger.info('Starting bot')
        running = true
        Signal.trap('INT') { running = false }
        fetch_updates(&block) while running
        exit
      end

      def fetch_updates
        response = api.getUpdates(options)
        return unless response['ok']

        response['result'].each do |data|
          update = Types::Update.new(data)
          @options[:offset] = update.update_id.next
          message = update.current_message
          log_incoming_message(message)
          yield message
        end
      rescue Faraday::TimeoutError
        retry
      end

      private

      def default_options
        {
          offset: 0,
          timeout: 20,
          logger: NullLogger.new,
          url: 'https://api.telegram.org'
        }
      end

      def log_incoming_message(message)
        uid = message.respond_to?(:from) && message.from ? message.from.id : nil
        logger.info(
          format('Incoming message: text="%s" uid=%s', message, uid)
        )
      end
    end
  end
end
