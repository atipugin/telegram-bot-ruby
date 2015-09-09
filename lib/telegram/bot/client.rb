module Telegram
  module Bot
    class Client
      TIMEOUT_EXCEPTIONS = [Timeout::Error]
      TIMEOUT_EXCEPTIONS << Net::ReadTimeout if Net.const_defined?(:ReadTimeout)

      attr_reader :api, :offset, :timeout, :logger

      def self.run(*args, &block)
        new(*args).run(&block)
      end

      def initialize(token, h = {})
        options = default_options.merge(h)
        @api = Api.new(token)
        @offset = options.delete(:offset)
        @timeout = options.delete(:timeout)
        @logger = options.delete(:logger)
        @scheduler = options.delete(:scheduler) || DefaultScheduler.new

        raise "Unknown arguments passed: #{options.keys.join(', ')}." unless options.empty?
      end

      def run
        yield self
      end

      def listen
        @scheduler.run do
          response = api.getUpdates(offset: offset, timeout: timeout)

          if response['ok']
            response['result'].each do |data|
              update = Types::Update.new(data)
              @offset = update.update_id.next
              log_incoming_message(update.message)
              yield update.message
            end
          end
        end
      rescue *TIMEOUT_EXCEPTIONS
        retry
      end

      private

      def default_options
        { offset: 0, timeout: 20, logger: NullLogger.new }
      end

      def log_incoming_message(message)
        logger.info(
          format(
            'Incoming message: text="%s" uid=%i',
            message.text,
            message.from.id
          )
        )
      end
    end
  end
end
