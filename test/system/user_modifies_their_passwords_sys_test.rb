require "application_system_test_case"

class UserModifiesTheirPasswordsSysTest < ApplicationSystemTestCase
  test "user modifies their password" do
    old_pass = 'password1'
    new_pass = 'oprepass'

    visit '/'

    click_link 'Log in'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: old_pass
    click_button 'Log in'

    click_on 'User One'

    fill_in 'Current password', with: old_pass
    fill_in 'Password', with: new_pass
    fill_in 'Password confirmation', with: new_pass
    click_on 'Change password'

    assert_selector 'div.border-b-2', text: 'Saved successfully'

    click_link 'Log out'
    click_link 'Log in'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: old_pass
    click_button 'Log in'

    assert_selector 'div.border-b-2', text: 'Username or password is incorrect'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: new_pass
    click_button 'Log in'

    assert_selector 'a#user_edit', text: 'User One'
  end
end
