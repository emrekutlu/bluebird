# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bluebird/version'

Gem::Specification.new do |spec|
  spec.name          = 'bluebird'
  spec.version       = Bluebird::VERSION
  spec.authors       = ['İ. Emre Kutlu']
  spec.email         = ["emrekutlu@gmail.com"]
  spec.description   = %q{Modifies your tweets mostly to fit 140 characters}
  spec.summary       = %q{Modifies your tweets}
  spec.homepage      = 'http://github.com/emrekutlu/bluebird'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'twitter-text', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
