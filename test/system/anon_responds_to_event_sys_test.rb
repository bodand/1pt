require "application_system_test_case"

class AnonRespondsToEventSysTest < ApplicationSystemTestCase
  test "sys anonymous can " do
    visit '/'

    fill_in 'Or open one by its id', with: '10'
    click_on 'Open'
    assert_selector 'h1.text-4xl', text: events(:nhf5).name

    first_row_date = find 'div', exact_text: 'May 29, 2024 10:00', normalize_ws: true
    first_row_date.sibling('div').click_on('Available')
    assert_selector '#response_entry_0[value="ok"]', visible: false

    sec_row_date = find 'div', exact_text: 'May 30, 2024 09:00', normalize_ws: true
    sec_row_date.sibling('div').click_on('Maybe')
    assert_selector '#response_entry_1[value="maybe"]', visible: false

    fill_in 'Respond as', with: 'Anonymous user'

    click_on 'Save Response'

    assert_selector 'div.border-b-2.border-charcoal', text: 'Thank you for responding'
    assert_selector 'h1.text-4xl', text: 'Welcome to 1pt!'
  end
end
