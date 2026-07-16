# frozen_string_literal: true

require_relative 'lib/telegram/bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'telegram-bot-ruby'
  spec.version       = Telegram::Bot::VERSION
  spec.authors       = ['Alexander Tipugin']
  spec.email         = ['atipugin@gmail.com']

  spec.summary       = "Ruby wrapper for Telegram's Bot API"
  spec.homepage      = 'https://github.com/atipugin/telegram-bot'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'dry-struct', '~> 1.6'
  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-multipart', '~> 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'
end
