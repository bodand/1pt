require "test_helper"

class CreateNewEventTest < ActionDispatch::IntegrationTest
  test "user can create new test" do
    do_login
    refute_ui_errors
    assert_select 'a#user_new_event', 'New event'

    get new_event_path
    assert_response :success
    assert_select 'h1.text-4xl', 'New event'

    name = SecureRandom.hex
    post events_path,
         params: {
           event: {
             name: name,
             event_entries: [
               {
                 date: "2024-05-27",
                 time: '11:12'
               },
               {
                 date: "2024-05-26",
                 time: '12:12'
               },
               {
                 date: "2024-05-25",
                 time: '13:12'
               }
             ]
           }
         },
         headers: { HTTP_REFERER: new_event_path }
    assert_response :redirect
    assert_redirected_to events_path

    follow_redirect!
    refute_ui_errors
    assert_select 'h1.text-4xl', 'My events'
    assert_select 'div.grid > div.text-xl.col-1', name
  end
end
