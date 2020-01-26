lib = File.expand_path('../lib', __FILE__)
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

  spec.add_dependency 'faraday'
  spec.add_dependency 'virtus'
  spec.add_dependency 'inflecto'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop', '~> 0.48.1'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.8'
end
