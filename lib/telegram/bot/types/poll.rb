# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Poll < Base
        attribute :id, Types::String
        attribute :question, Types::String.constrained(min_size: 1, max_size: 300)
        attribute? :question_entities, Types::Array.of(MessageEntity)
        attribute :options, Types::Array.of(PollOption)
        attribute :total_voter_count, Types::Integer
        attribute :is_closed, Types::Bool
        attribute :is_anonymous, Types::Bool
        attribute :type, Types::String
        attribute :allows_multiple_answers, Types::Bool
        attribute :allows_revoting, Types::Bool
        attribute :members_only, Types::Bool
        attribute? :country_codes, Types::Array.of(Types::String)
        attribute? :correct_option_ids, Types::Array.of(Types::Integer)
        attribute? :explanation, Types::String
        attribute? :explanation_entities, Types::Array.of(MessageEntity)
        attribute? :explanation_media, PollMedia
        attribute? :open_period, Types::Integer
        attribute? :close_date, Types::Integer
        attribute? :description, Types::String
        attribute? :description_entities, Types::Array.of(MessageEntity)
        attribute? :media, PollMedia
      end
    end
  end
end
