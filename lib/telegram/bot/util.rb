module Telegram
  module Bot
    module Util
      def deep_array_send(arr, method_name)
        arr.map do |item|
          if item.is_a?(Array)
            deep_array_send(item, method_name)
          else
            item.send(method_name)
          end
        end
      end

      module_function :deep_array_send
    end
  end
end
