# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dr_roboto/version'

Gem::Specification.new do |spec|
  spec.name          = "dr_roboto"
  spec.version       = DrRoboto::VERSION
  spec.authors       = ["lipanski"]
  spec.email         = ["florinelul@gmail.com"]
  spec.description   = %q{A simple Sinatra API for an imaginary robot treatment center.}
  spec.summary       = %q{A simple Sinatra API for an imaginary robot treatment center.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "mysql2"
  spec.add_dependency "activerecord"
  spec.add_dependency "sinatra-activerecord"
  spec.add_dependency "dotenv"
  spec.add_dependency "json"
  spec.add_dependency "paper_trail"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rerun"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "database_cleaner"
end
