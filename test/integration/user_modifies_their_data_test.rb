require "test_helper"

class UserModifiesTheirDataTest < ActionDispatch::IntegrationTest
  test "user modifies their name" do
    new_name = users(:two).name + ' AAA'

    do_login
    assert_select 'a#user_edit', users(:two).name

    get user_edit_path(users(:two))
    assert_response :success
    assert_select 'h3.text-2xl', 'Change user data'
    assert_select 'input#user_name', value: users(:two).name

    patch update_user_path(users(:two)),
          params: { user: { name: new_name, username: users(:two).username, email: users(:two).email } },
          headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    assert_response :redirect
    assert_redirected_to user_edit_path(users(:two))

    follow_redirect!
    assert_response :success
    assert_ui_msg 'Saved successfully'
    assert_select 'a#user_edit', new_name
    assert_select 'input#user_name', value: new_name
  end
end
