require "application_system_test_case"

class CreateNewEventSysTest < ApplicationSystemTestCase
  test "sys user can create a new event" do
    visit '/'

    click_link 'Log in'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: 'password1'
    click_button 'Log in'

    assert_selector 'a#user_edit', text: 'User One'
    click_on 'Create new event'

    name = SecureRandom.hex
    fill_in 'Name', with: name

    click_on id: 'add_apt'
    click_on id: 'add_apt'
    click_on id: 'add_apt'

    fill_in id: 'event_date_0', with: '2024-05-27'
    fill_in id: 'event_date_1', with: '2024-05-26'
    fill_in id: 'event_date_2', with: '2024-05-25'
    fill_in id: 'event_time_0', with: '11:12'
    fill_in id: 'event_time_1', with: '12:12'
    fill_in id: 'event_time_2', with: '13:12'

    click_on 'Create event'

    assert_selector 'h1.text-4xl', text: 'My events'
    assert_selector 'div.grid > div.text-xl.col-1', text: name

    click_on 'Log out'
    assert_selector 'a', text: 'Log in'
  end
end
