require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "empty User is invalid" do
    sut = new_user
    assert_invalid sut, username: :blank, password: :blank, email: :blank
  end

  test "User without username is invalid" do
    sut = new_user password: 'password123', email: 'test@exmaple.org'
    assert_invalid sut, username: :blank
  end

  test "User without password is invalid" do
    sut = new_user username: 'AAAAA', email: 'test@exmaple.org'
    assert_invalid sut, password: :blank
  end

  test "User without email is invalid" do
    sut = new_user username: 'AAAAA', password: 'password123'
    assert_invalid sut, email: :blank
  end

  test "User with invalid email is invalid" do
    sut = new_user email: 'invalid email address'
    assert_invalid sut, email: I18n.t('errors.invalid_email')
  end

  test "User with invalid username is invalid" do
    sut = new_user username: '¤¤¤¤¤'
    assert_invalid sut, username: I18n.t('errors.illegal_char')
  end

  test "User with invalid name is invalid" do
    sut = new_user name: '¤¤¤¤¤'
    assert_invalid sut, name: I18n.t('errors.illegal_char')
  end

  test "User with already in use email is invalid" do
    sut = new_user email: users(:one).email
    assert_invalid sut, email: "has already been taken"
  end

  test "User with already in use username is invalid" do
    sut = new_user username: users(:one).username
    assert_invalid sut, username: "has already been taken"
  end

  test "missing user does not authenticate" do
    found = User.authenticate "MISSING_USER", 'irrelevant'
    assert_nil found
  end

  test "user with invalid password does not authenticate" do
    found = User.authenticate users(:one).username, 'INVALID PASSWORD STRING'
    assert_nil found
  end

  test "user with valid password authenticates" do
    found = User.authenticate users(:one).username, 'password1'
    assert_not_nil found
    assert_equal users(:one), found
  end

  private

  def new_user(**args)
    User.new(id: -1, **args)
  end
end
