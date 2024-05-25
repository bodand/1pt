require "test_helper"

class EventControllerTest < ActionDispatch::IntegrationTest
  test "events new fails when not logged in" do
    get new_event_path
    assert_redirected_to login_path
    follow_redirect!

    assert_response :success
    assert_ui_error 'You must be logged in to create an event'
  end

  test "events new has required fields in form" do
    do_login

    get new_event_path
    assert_response :success
    assert_select 'form#new_event', action: events_path, method: 'post' do |f|
      assert_select f, 'label[for=event_name]', text: 'Name'
      assert_select f, 'label[for=event_name] ~ input[type=text]', name: 'event[name]', value: ''
      assert_select f, 'label[for=same_date]', text: 'Same date'
      assert_select f, 'label[for=same_date] ~ input[type=checkbox]', name: 'same_date'
      assert_select f, 'label[for=same_time]', text: 'Same time'
      assert_select f, 'label[for=same_time] ~ input[type=checkbox]', name: 'same_time'
      assert_select f, 'label[for=event_for_user]', text: 'For user'
      assert_select f, 'label[for=event_for_user] ~ button#for_user', count: 1
      assert_select f, 'div.mt-4.mb-1.flex.flex-row > h2.text-2xl', 'Possible appointments'
      assert_select f, 'div.mt-4.mb-1.flex.flex-row > h2.text-2xl ~ button[name=button]', count: 1
      assert_select f, 'button[type="submit"]', count: 1, text: 'Create event'
    end
  end

  test "events create fails when not logged in" do
    post events_path, params: { event: { name: 'broken' } }
    assert_redirected_to login_path
    follow_redirect!

    assert_response :success
    assert_ui_error 'You must be logged in to create an event'
  end

  test "events create fails with undefined entries" do
    do_login

    post events_path, params: { event: { name: 'broken' } }
    assert_redirected_to new_event_path
    follow_redirect!

    assert_response :success
    assert_ui_error 'Must specify appointments'
  end

  test "events create fails with empty entries" do
    do_login

    post events_path, params: { event: { name: 'broken', event_entries: [] } }
    assert_redirected_to new_event_path
    follow_redirect!

    assert_response :success
    assert_ui_error 'Must specify appointments'
  end

  test "events create fails with invalid event data" do
    do_login

    post events_path, params: { event: {
      name: '',
      event_entries: [{ date: nil, time: nil }]
    } }
    assert_redirected_to new_event_path
    follow_redirect!

    assert_response :success
    assert_ui_error "Name can't be blank"
  end

  test 'events index is redirects to login if not logged in' do
    get events_path
    assert_redirected_to login_path
  end

  test 'events index is empty for users without events' do
    do_login

    get events_path
    assert_response :success
    assert_select 'div.grid > *', count: 0
  end

  test "events create creates new event" do
    do_login

    post events_path, params: { event: {
      name: 'Test',
      event_entries: [{ date: Date.today.advance(days: 1), time: Time.now }]
    } }
    assert_redirected_to events_path
    follow_redirect!

    assert_response :success
    assert_select 'h1.text-4xl', text: 'My events', count: 1
    assert_select 'div.text-xl.col-1', text: 'Test', count: 1
    assert_select 'div.text-xl.col-1 ~ a.col-2', text: 'Respond', count: 1
    assert_select 'div.text-xl.col-1 ~ a.col-2 ~ a.col-3', text: 'See responses', count: 1
  end

  test "events find event redirects back if id missing" do
    post find_events_path
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'Event identifier must be provided'
  end

  test "events find event redirects back if id is invalid" do
    post find_events_path(event_id: -events(:pizza).id)
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'Invalid event identifier'
  end

  test "events event redirects back if id is invalid" do
    get event_path(-events(:pizza).id)
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'There is no such event'
  end

  test "events event renders event for valid id when not logged in" do
    get event_path(events(:pizza).id)
    assert_response :success
    assert_select 'h1.text-4xl', text: 'Event:', count: 1
    assert_select 'h1.text-4xl ~ h1.text-4xl', text: events(:pizza).name, count: 1
    events(:pizza).event_entries.each do |e|
      assert_select 'div.text-xl.col-1', text: e.as_rendered, count: 1
    end
    assert_select 'div.flex.flex-col > h2.text-xl', count: 1, text: 'Respond as'
    assert_select 'div.flex.flex-col > h2.text-xl ~ input[type=text]', count: 1
    assert_select 'div.flex.flex-col > input[type=submit]', count: 1, value: 'Save Response'
  end

  test "events event renders event for valid id when logged in" do
    do_login

    get event_path(events(:pizza))
    assert_response :success
    assert_select 'h1.text-4xl', text: 'Event:', count: 1
    assert_select 'h1.text-4xl ~ h1.text-4xl', text: events(:pizza).name, count: 1
    events(:pizza).event_entries.each do |e|
      assert_select 'div.text-xl.col-1', text: e.as_rendered, count: 1
    end
    assert_select 'div.flex.flex-col > h2.text-xl', count: 0, text: 'Respond as'
    assert_select 'div.flex.flex-col > h2.text-xl ~ input[type=text]', count: 0
    assert_select 'div.flex.flex-col > input[type=submit]', count: 1, value: 'Save Response'
  end

  test "events get_responses redirects back if id is invalid" do
    get event_responses_path(-events(:pizza).id)
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'There is no such event'
  end

  test "events get_responses renders responses" do
    get event_responses_path(events(:pizza).id)
    assert_response :success
    refute_ui_errors

    events(:pizza).event_entries.each_with_index do |e, e_idx|
      assert_select 'div.grid > div.text-xl.col-1', text: e.as_rendered, count: 1
      mapping = {}
      e.response_entries.each do |r|
        mapping[r.stat] ||= 0
        mapping[r.stat] += 1
      end
      mapping.each do |stat, val|
        assert_select "div.grid > button#btn_#{e_idx}_#{stat}", text: val.to_s, count: 1
      end
    end
  end

  test "events save redirects back if id is invalid" do
    post event_fill_path(-events(:pizza).id)
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'There is no such event'
  end

  test "events save redirects back if response data is invalid" do
    post event_fill_path(events(:pizza)), params: {
      response: {
        responder: '¤'
      }
    }
    assert_redirected_to root_page_path
    follow_redirect!
    assert_ui_error 'Responder contains illegal characters'
  end

  test "events save saves response and redirects to root" do
    post event_fill_path(events(:pizza)), params: {
      response: {
        responder: 'A',
        entry: {
          1 => "maybe",
          2 => "maybe",
        }
      }
    }
    assert_redirected_to root_page_path
    follow_redirect!
    refute_ui_errors
    assert_ui_msg 'Thank you for responding'
  end
end
