source 'https://rubygems.org'

# Specify your gem's dependencies in did_you_mean-activerecord.gemspec
gemspec

if RUBY_VERSION >= '2.4.0'
  gem "did_you_mean", "1.1.0"
elsif RUBY_VERSION < '2.4.0' && RUBY_VERSION >= '2.3.0'
  gem "did_you_mean", "1.0.2"
else
  raise "The Ruby version #{RUBY_VERSION} does not support did_you_mean"
end

gem 'sqlite3'
gem 'pg'
gem 'mysql2'
