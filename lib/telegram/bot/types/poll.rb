# frozen_string_literal: true

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
        attribute :explanation, String
        attribute :explanation_entities, Array[MessageEntity]
        attribute :open_period, Integer
        attribute :close_date, Integer
      end
    end
  end
end
