# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberRestricted < Base
        attribute :status, Types::String.constrained(eql: 'restricted').default('restricted')
        attribute :user, User
        attribute :is_member, Types::Bool
        attribute :can_send_messages, Types::Bool
        attribute :can_send_audios, Types::Bool
        attribute :can_send_documents, Types::Bool
        attribute :can_send_photos, Types::Bool
        attribute :can_send_videos, Types::Bool
        attribute :can_send_video_notes, Types::Bool
        attribute :can_send_voice_notes, Types::Bool
        attribute :can_send_polls, Types::Bool
        attribute :can_send_other_messages, Types::Bool
        attribute :can_add_web_page_previews, Types::Bool
        attribute :can_change_info, Types::Bool
        attribute :can_invite_users, Types::Bool
        attribute :can_pin_messages, Types::Bool
        attribute :can_manage_topics, Types::Bool
        attribute :until_date, Types::Integer
      end
    end
  end
end
