require 'test_helper'

class AttributeNameCorrectionTest < Minitest::Test
  def setup
    CreateUserTable.up

    @error = assert_raises(ActiveRecord::UnknownAttributeError) do
      User.new(flrst_name: "wrong flrst name")
    end
  end

  def teardown
    CreateUserTable.down
  end

  def test_corrections
    assert_correction "first_name: string", @error.corrections
  end

  def test_did_you_mean?
    assert_match "Did you mean?  first_name: string", @error.message
  end
end
