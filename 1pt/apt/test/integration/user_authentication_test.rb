# frozen_string_literal: true

require 'minitest/autorun'

class UserAuthenticationTest < Minitest::Test
  Password = 'Password'
  Username = 'Test'

  def setup
    User.create! username: Username, password: Password
  end

  def teardown
  end

  def test
    assert User.authenticate(Username, Password)
  end
end
