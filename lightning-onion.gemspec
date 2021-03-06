# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lightning/onion/version'

Gem::Specification.new do |spec|
  spec.name          = 'lightning-onion'
  spec.version       = Lightning::Onion::VERSION
  spec.authors       = ['Hajime Yamaguchi']
  spec.email         = ['gen.yamaguchi0@gmail.com']

  spec.summary       = 'Onion routing for the Lightning Network.'
  spec.description   = 'Onion routing for the Lightning Network.'
  spec.homepage      = 'https://github.com/Yamaguchi/lightning-onion'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'algebrick'
  spec.add_runtime_dependency 'bitcoinrb'
  spec.add_runtime_dependency 'rbnacl'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
