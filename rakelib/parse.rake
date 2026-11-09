# frozen_string_literal: true

require_relative 'parsers/docs_page'
require_relative 'parsers/serializer'

namespace :parse do
  Parsers::Serializer::FILES.each_key do |name|
    desc "Parse #{name} from data/bot_api.html"
    task name do
      File.write Parsers::Serializer.path(name), Parsers::Serializer.new(Parsers::DocsPage.load).render(name)
      puts "Written to data/#{name}.json"
    end
  end
end
