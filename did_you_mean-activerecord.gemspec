# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'did_you_mean/activerecord/version'

Gem::Specification.new do |spec|
  spec.name          = "did_you_mean-activerecord"
  spec.version       = DidYouMean::ActiveRecord::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["mail@yukinishijima.net"]
  spec.summary       = %q{"Did you mean" experience in Rails}
  spec.description   = %q{did_you_mean-activerecord adds a "Did you mean" feature to ActiveRecord.}
  spec.homepage      = "http://github.com/yuki24/did_you_mean-activerecord"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency "did_you_mean", '>= 1.0.2'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord", '>= 4.1.0'
  spec.add_development_dependency "railties", '>= 4.1.0'
end
