# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_to_model_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'hash_to_model_mapper'
  spec.version       = HashToModelMapper::VERSION
  spec.authors       = ['AlexVko']
  spec.email         = ['ale@alexvko.com']

  spec.summary       = 'Set schemas to convert hashes/json from different sources to ActiveRecord models'
  spec.homepage      = 'https://github.com/alexvko/hash_to_model_mapper'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'activesupport', '>= 5.2', '< 7.0'
end
