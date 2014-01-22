# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "data_kit"
  spec.version       = DataKit::VERSION
  spec.authors       = ["Mode Analytics"]
  spec.email         = ["support@modeanalytics.com"]
  spec.description   = %q{Library for ingesting, analyzing and normalizing datasets in various formats}
  spec.summary       = %q{Provides parsers, analyzers and converters for datasets stored in various formats}
  spec.homepage      = "http://www.modeanalytics.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Runtime Dependencies
  spec.add_runtime_dependency "timeliness"

  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "profile"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
