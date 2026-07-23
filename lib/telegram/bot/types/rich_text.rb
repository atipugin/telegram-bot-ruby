# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      RichText = (
        RichTextBold |
        RichTextItalic |
        RichTextUnderline |
        RichTextStrikethrough |
        RichTextSpoiler |
        RichTextDateTime |
        RichTextTextMention |
        RichTextSubscript |
        RichTextSuperscript |
        RichTextMarked |
        RichTextCode |
        RichTextCustomEmoji |
        RichTextMathematicalExpression |
        RichTextUrl |
        RichTextEmailAddress |
        RichTextPhoneNumber |
        RichTextBankCardNumber |
        RichTextMention |
        RichTextHashtag |
        RichTextCashtag |
        RichTextBotCommand |
        RichTextAnchor |
        RichTextAnchorLink |
        RichTextReference |
        RichTextReferenceLink
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
