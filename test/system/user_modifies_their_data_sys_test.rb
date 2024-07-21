require "application_system_test_case"

class UserModifiesTheirDataSysTest < ApplicationSystemTestCase
  test "user modifies their name" do
    visit '/'

    click_link 'Log in'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: 'password1'
    click_button 'Log in'

    click_on 'User One'

    new_name = users(:two).name + ' AAA'
    fill_in 'Name', with: new_name
    click_on 'Save'

    assert_selector 'a#user_edit', text: new_name
    assert_selector 'div.border-b-2', text: 'Saved successfully'
  end
end
