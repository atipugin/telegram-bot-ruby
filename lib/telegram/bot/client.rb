module Telegram
  module Bot
    class Client
      attr_reader :api, :options
      attr_accessor :logger

      def self.run(*args, &block)
        new(*args).run(&block)
      end

      def initialize(token, h = {})
        @options = default_options.merge(h)
        @api = Api.new(token)
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
          message = extract_message(update)
          log_incoming_message(message)
          yield message
        end
      rescue Faraday::Error::TimeoutError
        retry
      end

      private

      def default_options
        { offset: 0, timeout: 20, logger: NullLogger.new }
      end

      def extract_message(update)
        update.inline_query ||
          update.chosen_inline_result ||
          update.callback_query ||
          update.edited_message ||
          update.message
      end

      def log_incoming_message(message)
        uid = message.from ? message.from.id : nil
        logger.info(
          format('Incoming message: text="%s" uid=%s', message, uid)
        )
      end
    end
  end
end
