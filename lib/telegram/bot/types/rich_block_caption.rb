# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockCaption < Base
        attribute :text, RichText
        attribute? :credit, RichText
      end
    end
  end
end
