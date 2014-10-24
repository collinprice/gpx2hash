# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gpx2hash/version'

Gem::Specification.new do |spec|
  spec.name          = "gpx2hash"
  spec.version       = Gpx2hash::VERSION
  spec.authors       = ["Collin Price"]
  spec.email         = ["collin@collinprice.com"]
  spec.summary       = "Simple Ruby library that converts a GPX file into a Hash."
  spec.description   = "Simple Ruby library that converts a GPX file into a Hash."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "nokogiri"
  
end
