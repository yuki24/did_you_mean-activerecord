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

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "did_you_mean", '~> 0.10.0'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord", '>= 3.2.0'
  spec.add_development_dependency "railties", '>= 3.2.0'
end
