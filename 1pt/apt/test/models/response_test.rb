require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "empty Response object is invalid" do
    sut = new_response
    assert_invalid sut, user: :blank
  end

  test "Response with user is valid" do
    sut = new_response user: User.new
    assert_valid sut
  end

  test "Response with ill-formed responder is invalid" do
    sut = new_response responder: '¤¤¤'
    assert_invalid sut, responder: I18n.t('errors.illegal_char')
  end

  test "Response with well-formed responder is valid" do
    sut = new_response responder: 'John Doe'
    assert_valid sut
  end

  test "Response with without user has responder as name" do
    resp_name = 'John Doe'
    sut = new_response responder: resp_name
    assert_equal resp_name, sut.responder_name
  end

  test "Response with with user has user's name as name" do
    user = User.new(name: 'Basil Test')
    sut = new_response user: user
    assert_equal user.name, sut.responder_name
  end

  test "Response with with user has user's name with responder set as name" do
    resp_name = 'John Doe'
    user = User.new(name: 'Basil Test')
    sut = new_response user: user, responder: resp_name
    assert_equal user.name, sut.responder_name
  end

  private

  def new_response(**args)
    Response.new event: Event.new, **args
  end
end
