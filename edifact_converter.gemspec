# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'edifact_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "edifact_converter"
  spec.version       = EdifactConverter::VERSION
  spec.authors       = ["Jacob Glasdam"]
  spec.email         = ["jacob@medware.dk"]
  spec.summary       = %q{Converts an edifact file to simple xml.}
#  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
