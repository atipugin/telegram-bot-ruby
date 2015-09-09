module Telegram
  module Bot
    class Scheduler
      def run(&_block)
        # Do update on block
      end
    end

    # Just run updates in infinite loop
    class DefaultScheduler < Scheduler
      def run(&block)
        loop do
          yield block
        end
      end
    end
  end
end
