# frozen_string_literal: true

require 'net/http'
require_relative 'parsers/docs_page'

namespace :docs do
  desc 'Download the Telegram Bot API documentation to data/bot_api.html'
  task :fetch do
    response = Net::HTTP.get_response(URI(Parsers::DocsPage::URL))
    raise "Failed to fetch #{Parsers::DocsPage::URL}: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    File.write Parsers::DocsPage::SNAPSHOT_PATH, Parsers::DocsPage.parse(response.body).to_html
    puts 'Written to data/bot_api.html'
  end
end
