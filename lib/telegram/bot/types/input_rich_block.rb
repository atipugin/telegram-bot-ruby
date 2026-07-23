# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      InputRichBlock = (
        InputRichBlockParagraph |
        InputRichBlockSectionHeading |
        InputRichBlockPreformatted |
        InputRichBlockFooter |
        InputRichBlockDivider |
        InputRichBlockMathematicalExpression |
        InputRichBlockAnchor |
        InputRichBlockList |
        InputRichBlockBlockQuotation |
        InputRichBlockPullQuotation |
        InputRichBlockCollage |
        InputRichBlockSlideshow |
        InputRichBlockTable |
        InputRichBlockDetails |
        InputRichBlockMap |
        InputRichBlockAnimation |
        InputRichBlockAudio |
        InputRichBlockPhoto |
        InputRichBlockVideo |
        InputRichBlockVoiceNote |
        InputRichBlockThinking
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
