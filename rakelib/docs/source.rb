# frozen_string_literal: true

require 'net/http'
require 'fileutils'

module Docs
  # Fetches the Bot API documentation page and caches it under tmp/, so that
  # a parse run makes one request instead of one per parser, and re-running
  # during development costs nothing. The cache never expires on its own;
  # `rake parse:fetch` is the explicit refresh.
  class Source
    URL = 'https://core.telegram.org/bots/api'
    CACHE_PATH = File.expand_path('../../tmp/api.html', __dir__)

    attr_reader :url, :cache_path

    def initialize(url: URL, cache_path: CACHE_PATH)
      @url = url
      @cache_path = cache_path
    end

    def html
      @html ||= cached || download
    end

    def download
      body = Net::HTTP.get(URI.parse(url))
      FileUtils.mkdir_p(File.dirname(cache_path))
      File.write(cache_path, body)
      @html = body
    end

    def cached?
      File.exist?(cache_path)
    end

    private

    def cached
      cached? ? File.read(cache_path) : nil
    end
  end
end
