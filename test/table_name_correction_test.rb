require 'test_helper'

class TableNameCorrectionWithSelectTest < Minitest::Test
  def setup
    CreateUserTable.up
    User.all.to_a

    @error = assert_raises(ActiveRecord::StatementInvalid) do
      User.select("suers.foo").to_a
    end
  end

  def teardown
    CreateUserTable.down
  end

  def test_suggestions
    skip if sqlite3?

    assert_suggestion "users", @error.suggestions
  end

  def test_did_you_mean?
    skip if sqlite3?

    assert_match "Did you mean? users", @error.message
  end

  private

  def sqlite3?
    !ENV.has_key?('DATABASE_ADAPTER') || ENV['DATABASE_ADAPTER'] == 'sqlite3'
  end
end

class TableNameCorrectionWithFromTest < Minitest::Test
  def setup
    CreateUserTable.up
    User.all.to_a

    @error = assert_raises(ActiveRecord::StatementInvalid) do
      User.from("suers").to_a
    end
  end

  def teardown
    CreateUserTable.down
  end

  def test_suggestions
    assert_suggestion "users", @error.suggestions
  end

  def test_did_you_mean?
    assert_match "Did you mean? users", @error.message
  end
end
