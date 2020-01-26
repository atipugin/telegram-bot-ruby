module Telegram
  module Bot
    module Types
      class Poll < Base
        attribute :id, String
        attribute :question, String
        attribute :options, Array[PollOption]
        attribute :total_voter_count, Integer
        attribute :is_closed, Boolean
        attribute :is_anonymous, Boolean
        attribute :type, String
        attribute :allows_multiple_answers, Boolean
        attribute :correct_option_id, Integer
      end
    end
  end
end
