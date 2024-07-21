require "test_helper"

class UserWithDbTest < ActiveSupport::TestCase
  Password = 'Password'
  Username = 'Test'

  test "user authentication finds valid user" do
    assert User.authenticate(Username, Password)
  end
end
