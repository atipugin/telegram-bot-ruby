# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputInvoiceMessageContent < InputMessageContent
        attribute :title, String
        attribute :description, String
        attribute :payload, String
        attribute :provider_token, String
        attribute :currency, String
        attribute :prices, Array[LabeledPrice]
        attribute :max_tip_amount, Integer
        attribute :suggested_tip_amounts, Array[Integer]
        attribute :provider_data, String
        attribute :photo_url, String
        attribute :photo_size, Integer
        attribute :photo_width, Integer
        attribute :photo_height, Integer
        attribute :need_name, Boolean
        attribute :need_phone_number, Boolean
        attribute :need_email, Boolean
        attribute :need_shipping_address, Boolean
        attribute :send_phone_number_to_provider, Boolean
        attribute :send_email_to_provider, Boolean
        attribute :is_flexible, Boolean
      end
    end
  end
end
