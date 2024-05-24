require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "empty Event is invalid" do
    sut = new_event
    assert_invalid sut, name: :blank
  end

  test "Event with invalid character is invalid" do
    sut = new_event name: "\\\\\\"
    assert_invalid sut, name: I18n.t('errors.illegal_char')
  end

  test "Event with empty string name is invalid" do
    sut = new_event name: ""
    assert_invalid sut, name: :blank
  end

  test "Event with one character name is invalid" do
    sut = new_event name: "x"
    assert_invalid sut, name: [:too_short, count: 2]
  end

  test "Event with two character name is valid" do
    sut = new_event name: "xx"
    assert_valid sut
  end

  test "Event with 255 character name is valid" do
    sut = new_event name: "x" * 255
    assert_valid sut
  end

  test "Event with 256 character name is invalid" do
    sut = new_event name: "x" * 256
    assert_invalid sut, name: [:too_long, count: 255]
  end

  test "Event with valid name is valid" do
    sut = new_event name: "My favourite event"
    assert_valid sut
  end

  private

  def new_event(**args)
    Event.new(user: User.new, **args)
  end
end
