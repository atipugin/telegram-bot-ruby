# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'telegram/bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'telegram-bot-ruby'
  spec.version       = Telegram::Bot::VERSION
  spec.authors       = ['Alexander Tipugin']
  spec.email         = ['atipugin@gmail.com']

  spec.summary       = "Ruby wrapper for Telegram's Bot API"
  spec.homepage      = 'https://github.com/atipugin/telegram-bot'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-inflector'
  spec.add_dependency 'faraday', '~> 1.0'
  spec.add_dependency 'virtus', '~> 2.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 1.27'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.10'
end
