# frozen_string_literal: true

require_relative 'lib/conversion_factory/version'

Gem::Specification.new do |spec|
  spec.name          = 'conversion_factory'
  spec.version       = ConversionFactory::VERSION
  spec.authors       = ['Filipe Botelho']
  spec.email         = ['filipedesousab@gmail.com']

  spec.summary       = 'Ruby library to convert various file formats'
  spec.description   = 'User this gem to convert various file formats to various file formats'
  spec.homepage      = 'https://github.com/filipedesousab/conversion_factory'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
