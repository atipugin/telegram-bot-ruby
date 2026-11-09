# frozen_string_literal: true

require_relative '../../../rakelib/parsers/docs_page'
require_relative '../../../rakelib/parsers/serializer'

# Parsing the snapshot is slow, so the parser specs share one page.
module SnapshotPage
  def self.page
    @page ||= Parsers::DocsPage.load
  end
end
