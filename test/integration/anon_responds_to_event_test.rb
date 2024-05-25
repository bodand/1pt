require "test_helper"

class AnonRespondsToEventTest < ActionDispatch::IntegrationTest
  test "anonymous can respond to an event" do
    get root_page_path
    assert_response :success
    assert_select 'input#open_event', value: 'Open'

    post find_events_path(events(:nhf5)),
         params: { event_id: events(:nhf5).id, commit: 'Open' },
         headers: { HTTP_REFERER: root_page_path }
    assert_response :redirect
    assert_redirected_to event_path(events(:nhf5))

    follow_redirect!
    assert_select 'h1.text-4xl', events(:nhf5).name

    post event_fill_path(events(:nhf5)),
         params: {
           commit: 'Save Response',
           response: {
             responder: 'AnonResponder',
             entry: {
               0 => "no",
               1 => "no",
             }
           }
         },
         headers: { HTTP_REFERER: event_path(events(:nhf5)) }
    assert_response :redirect
    assert_redirected_to root_page_path

    follow_redirect!
    assert_ui_msg 'Thank you for responding'
  end
end
