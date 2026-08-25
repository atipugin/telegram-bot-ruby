# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      RichBlock = (
        RichBlockParagraph |
        RichBlockSectionHeading |
        RichBlockPreformatted |
        RichBlockFooter |
        RichBlockDivider |
        RichBlockMathematicalExpression |
        RichBlockAnchor |
        RichBlockList |
        RichBlockBlockQuotation |
        RichBlockExpandableBlockQuotation |
        RichBlockPullQuotation |
        RichBlockCollage |
        RichBlockSlideshow |
        RichBlockTable |
        RichBlockDetails |
        RichBlockMap |
        RichBlockButtons |
        RichBlockAnimation |
        RichBlockAudio |
        RichBlockDocument |
        RichBlockPhoto |
        RichBlockVideo |
        RichBlockVoiceNote |
        RichBlockThinking
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
