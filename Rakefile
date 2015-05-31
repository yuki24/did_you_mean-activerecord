require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << "test"
  task.pattern = 'test/**/*_test.rb'
  task.verbose = true
  # task.warning = true
end

task default: :test
