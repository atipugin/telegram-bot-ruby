# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaTypeSuggestedReaction < Base
        attribute :type, Types::String.constrained(eql: 'suggested_reaction').default('suggested_reaction')
        attribute :reaction_type, ReactionType
        attribute? :is_dark, Types::Bool
        attribute? :is_flipped, Types::Bool
      end
    end
  end
end
