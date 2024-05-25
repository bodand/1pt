require "test_helper"

class EventEntryTest < ActiveSupport::TestCase
  test "empty EventEntry results in UNIX epoch in UTC" do
    sut = EventEntry.new
    assert_equal DateTime.iso8601("1970-01-01T00:00:00Z"), sut.as_datetime
  end

  test "EventEntry with date results in midnight" do
    date = Date.iso8601("2000-03-02")
    sut = EventEntry.new date: date
    assert_equal DateTime.iso8601("#{date.iso8601}T00:00:00Z"), sut.as_datetime
  end

  test "EventEntry with time results in that time at the UNIX epoch" do
    time = Time.iso8601("2000-03-02T12:34:56Z")
    sut = EventEntry.new time: time
    assert_equal DateTime.iso8601("1970-01-01T#{time.strftime("%H:%M:%S%z")}"), sut.as_datetime
  end

  test "empty EventEntry renders as unknown date" do
    sut = EventEntry.new
    assert_equal 'Unknown date', sut.as_rendered
  end

  test "EventEntry with date renders as that date" do
    date = Date.iso8601("2000-03-02")
    sut = EventEntry.new date: date
    assert_equal I18n.l(date, format: :long), sut.as_rendered
  end

  test "EventEntry with time renders as that time" do
    time = Time.iso8601("2000-03-02T12:34:56Z")
    sut = EventEntry.new time: time
    assert_equal I18n.l(time, format: :time), sut.as_rendered
  end

  test "EventEntry with date and time renders as that datetime" do
    date = Date.iso8601("2000-03-02")
    time = Time.iso8601("1970-01-01T12:34:56Z")
    sut = EventEntry.new date: date, time: time
    assert_equal I18n.l(DateTime.iso8601("2000-03-02T12:34:56Z"), format: :long), sut.as_rendered
  end

  test "empty EventEntry is invalid" do
    sut = EventEntry.new
    assert_invalid sut, date: :blank
  end

  test "EventEntry with date is valid" do
    sut = EventEntry.new event: Event.new,
                         date: Date.iso8601("2000-03-02T12:34:56")
    assert_valid sut
  end

  test "EventEntry with time is valid" do
    sut = EventEntry.new event: Event.new,
                         time: Time.iso8601("2000-03-02T12:34:56Z")
    assert_valid sut
  end

  test "EventEntry with date and time is valid" do
    sut = EventEntry.new event: Event.new,
                         date: Date.iso8601("2000-03-02T12:34:56"),
                         time: Time.iso8601("2000-03-02T12:34:56Z")
    assert_valid sut
  end
end
