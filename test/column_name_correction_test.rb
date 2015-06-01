require 'test_helper'

class ColumnNameCorrectionTest < Minitest::Test
  def setup
    CreateUserTable.up

    @error = assert_raises(ActiveRecord::StatementInvalid) do
      User.select("firstname").to_a
    end
  end

  def teardown
    CreateUserTable.down
  end

  def test_suggestions
    assert_suggestion "first_name", @error.suggestions
  end

  def test_did_you_mean?
    assert_match "Did you mean? first_name", @error.message
  end
end
