#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

# All methods from Telegram Bot API documentation
telegram_api_methods = [
  "addStickerToSet",
  "answerCallbackQuery",
  "answerInlineQuery",
  "answerPreCheckoutQuery",
  "answerShippingQuery",
  "answerWebAppQuery",
  "approveChatJoinRequest",
  "approveSuggestedPost",
  "banChatMember",
  "banChatSenderChat",
  "close",
  "closeForumTopic",
  "closeGeneralForumTopic",
  "convertGiftToStars",
  "copyMessage",
  "copyMessages",
  "createChatInviteLink",
  "createForumTopic",
  "createInvoiceLink",
  "createNewStickerSet",
  "declineChatJoinRequest",
  "declineSuggestedPost",
  "deleteBusinessMessages",
  "deleteChatPhoto",
  "deleteChatStickerSet",
  "deleteForumTopic",
  "deleteMessage",
  "deleteMessages",
  "deleteMyCommands",
  "deleteStickerFromSet",
  "deleteStickerSet",
  "deleteStory",
  "deleteWebhook",
  "editChatInviteLink",
  "editForumTopic",
  "editGeneralForumTopic",
  "editMessageCaption",
  "editMessageChecklist",
  "editMessageLiveLocation",
  "editMessageMedia",
  "editMessageReplyMarkup",
  "editMessageText",
  "editStory",
  "exportChatInviteLink",
  "forwardMessage",
  "forwardMessages",
  "getBusinessAccountGifts",
  "getBusinessAccountStarBalance",
  "getBusinessConnection",
  "getChat",
  "getChatAdministrators",
  "getChatMember",
  "getChatMemberCount",
  "getChatMenuButton",
  "getCustomEmojiStickers",
  "getFile",
  "getForumTopicIconStickers",
  "getGameHighScores",
  "getMe",
  "getMyCommands",
  "getMyDefaultAdministratorRights",
  "getMyDescription",
  "getMyName",
  "getMyShortDescription",
  "getMyStarBalance",
  "getStarTransactions",
  "getStickerSet",
  "getUserChatBoosts",
  "getUserProfilePhotos",
  "getUpdates",
  "getWebhookInfo",
  "giftPremiumSubscription",
  "hideGeneralForumTopic",
  "leaveChat",
  "logOut",
  "pinChatMessage",
  "postStory",
  "promoteChatMember",
  "readBusinessMessage",
  "refundStarPayment",
  "removeBusinessAccountProfilePhoto",
  "reopenForumTopic",
  "reopenGeneralForumTopic",
  "replaceStickerInSet",
  "restrictChatMember",
  "revokeChatInviteLink",
  "sendAnimation",
  "sendAudio",
  "sendChatAction",
  "sendChecklist",
  "sendContact",
  "sendDice",
  "sendDocument",
  "sendGame",
  "sendGift",
  "sendInvoice",
  "sendLocation",
  "sendMediaGroup",
  "sendMessage",
  "sendPaidMedia",
  "sendPhoto",
  "sendPoll",
  "sendSticker",
  "sendVenue",
  "sendVideo",
  "sendVideoNote",
  "sendVoice",
  "setBusinessAccountBio",
  "setBusinessAccountGiftSettings",
  "setBusinessAccountName",
  "setBusinessAccountProfilePhoto",
  "setBusinessAccountUsername",
  "setChatAdministratorCustomTitle",
  "setChatDescription",
  "setChatMenuButton",
  "setChatPermissions",
  "setChatPhoto",
  "setChatStickerSet",
  "setChatTitle",
  "setCustomEmojiStickerSetThumbnail",
  "setGameScore",
  "setMessageReaction",
  "setMyCommands",
  "setMyDefaultAdministratorRights",
  "setMyDescription",
  "setMyName",
  "setMyShortDescription",
  "setPassportDataErrors",
  "setStickerEmojiList",
  "setStickerKeywords",
  "setStickerMaskPosition",
  "setStickerPositionInSet",
  "setStickerSetThumbnail",
  "setStickerSetTitle",
  "setWebhook",
  "stopMessageLiveLocation",
  "stopPoll",
  "transferBusinessAccountStars",
  "transferGift",
  "unbanChatMember",
  "unbanChatSenderChat",
  "unhideGeneralForumTopic",
  "unpinAllChatMessages",
  "unpinAllForumTopicMessages",
  "unpinChatMessage",
  "upgradeGift",
  "uploadStickerFile"
]

# Load methods from codebase
endpoints_json = File.read('data/endpoints.json')
codebase_methods = JSON.parse(endpoints_json).keys.sort

# Find missing methods
missing_methods = telegram_api_methods - codebase_methods

# Find extra methods (in codebase but not in API docs)
extra_methods = codebase_methods - telegram_api_methods

# Print report
puts "=" * 80
puts "TELEGRAM BOT API METHODS VERIFICATION REPORT"
puts "=" * 80
puts ""
puts "Total methods in Telegram Bot API documentation: #{telegram_api_methods.size}"
puts "Total methods in codebase (data/endpoints.json): #{codebase_methods.size}"
puts ""

if missing_methods.empty?
  puts "✓ ALL API methods are present in the codebase!"
else
  puts "✗ Missing #{missing_methods.size} methods from the codebase:"
  puts ""
  missing_methods.each_with_index do |method, index|
    puts "  #{index + 1}. #{method}"
  end
end

puts ""

if extra_methods.any?
  puts "⚠ Extra methods in codebase (not in API docs):"
  puts ""
  extra_methods.each_with_index do |method, index|
    puts "  #{index + 1}. #{method}"
  end
  puts ""
end

puts "=" * 80

# Save detailed report to file
File.write('missing_methods_report.txt', <<~REPORT)
  TELEGRAM BOT API METHODS VERIFICATION REPORT
  Generated: #{Time.now}

  Summary:
  --------
  Total methods in Telegram Bot API: #{telegram_api_methods.size}
  Total methods in codebase: #{codebase_methods.size}
  Missing methods: #{missing_methods.size}
  Extra methods: #{extra_methods.size}

  Missing Methods:
  ----------------
  #{missing_methods.empty? ? 'None - all methods are present!' : missing_methods.map.with_index(1) { |m, i| "#{i}. #{m}" }.join("\n")}

  Extra Methods (in codebase but not in API docs):
  -------------------------------------------------
  #{extra_methods.empty? ? 'None' : extra_methods.map.with_index(1) { |m, i| "#{i}. #{m}" }.join("\n")}

  Methods Present in Both:
  ------------------------
  #{(codebase_methods & telegram_api_methods).map.with_index(1) { |m, i| "#{i}. #{m}" }.join("\n")}
REPORT

puts ""
puts "✓ Detailed report saved to: missing_methods_report.txt"
