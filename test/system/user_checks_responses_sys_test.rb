require "application_system_test_case"

class UserChecksResponsesSysTest < ApplicationSystemTestCase
  test "sys user checks responses to its " do
    visit '/'

    click_link 'Log in'

    fill_in 'Username', with: 'user1'
    fill_in 'Password', with: 'password1'
    click_button 'Log in'

    click_on 'My events'

    # i don't think you can find this without xpath, or a specific id
    find(:xpath,
         '//div[normalize-space()="Pizza"]/following-sibling::a',
         text: 'See responses').click
    assert_selector 'h1.text-4xl', text: 'Pizza'

    click_on 'Log out'
    assert_selector 'a', text: 'Log in'
  end
end
