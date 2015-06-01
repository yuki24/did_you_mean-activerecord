$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/unit'

begin
  MiniTest::Test
rescue NameError
  MiniTest::Test = MiniTest::Unit::TestCase
end

require 'did_you_mean'
require 'did_you_mean/test_helper'
MiniTest::Test.send :include, DidYouMean::TestHelper

require 'rails'
require 'activerecord/correctable' # TODO: change it to "active_record"
require 'fake_app'




