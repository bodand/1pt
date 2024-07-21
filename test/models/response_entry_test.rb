require "test_helper"

class ResponseEntryTest < ActiveSupport::TestCase
  test "empty ResponseEntry is invalid" do
    sut = new_resentry
    assert_invalid sut, stat: :blank
  end

  test "ResponseEntry with invalid status is invalid" do
    invalid_stat = 'AAAAAAAAAAAAAAAAAA'
    sut = new_resentry stat: invalid_stat
    assert_invalid sut, stat: I18n.t('errors.invalid_status') % { value: invalid_stat }
  end

  test "ResponseEntry with valid status is valid" do
    sut = new_resentry stat: 'ok'
    assert_valid sut
  end

  private

  def new_resentry(**args)
    ResponseEntry.new id: -1, response: Response.new(id: -1), event_entry: EventEntry.new(id: -1), **args
  end
end
