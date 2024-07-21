require "test_helper"

class UserChecksResponsesTest < ActionDispatch::IntegrationTest
  test "user checks responses to an event" do
    do_login :one, 'password1'

    get root_page_path
    assert_response :success
    assert_select 'a#user_events', 'My events'

    get events_path
    assert_response :success
    assert_select 'h1.text-4xl', 'My events'
    assert_select "div.grid > a[href=\"#{event_responses_path(events(:pizza))}\"]", 'See responses'

    get event_responses_path(events(:pizza))
    assert_response :success
    assert_select 'h1.text-4xl', events(:pizza).name

    get session_logout_path
    assert_response :redirect
    assert_redirected_to root_page_path

    follow_redirect!
    assert_select 'a#user_edit', count: 0, text: users(:one).name
  end
end
