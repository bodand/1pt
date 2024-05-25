require "test_helper"

class UserModifiesTheirPasswordTest < ActionDispatch::IntegrationTest
  test "user modifies their password" do
    new_pass = 'oprepass'

    do_login
    assert_select 'a#user_edit', users(:two).name

    get user_edit_path(users(:two))
    assert_response :success
    assert_select 'h3.text-2xl', 'Change password'
    assert_select 'input[type=password]', value: '', count: 3

    patch update_user_passwd_path(users(:two)),
          params: { user: { current_password: 'password2', password: new_pass, password_confirmation: new_pass } },
          headers: { HTTP_REFERER: user_edit_path(users(:two)) }
    assert_response :redirect
    assert_redirected_to user_edit_path(users(:two))

    follow_redirect!
    assert_response :success
    assert_ui_msg 'Saved successfully'

    get session_logout_path
    assert_response :redirect
    assert_redirected_to root_page_path

    do_login :two, new_pass
  end
end
