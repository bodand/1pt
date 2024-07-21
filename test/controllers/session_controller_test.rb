require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
  test 'user login can login with valid user data' do
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'password2'
      }
    }
    follow_redirect!
    refute_nil session[:user_id]
    assert_nil flash[:errors]
    assert_select "a#create_event", "Create new event"
    assert_select "a#user_edit", href: "/users/#{session[:user_id]}", text: users(:two).name
    assert_select "a#user_logout", href: '/sessions/logout', text: I18n.t('usr.log_out')
  end

  test 'user login cannot login with valid user data' do
    post session_login_path, params: {
      user: {
        username: users(:two).username,
        password: 'INVALID PASSWORD VALUE'
      }
    }
    follow_redirect!
    assert_nil session[:user_id]
    refute_empty flash[:errors]
    assert_select "a#create_event", "Create new event"
    assert_select "a#register_btn", href: '/register', text: I18n.t('usr.register')
    assert_select "a#login_btn", href: '/login', text: I18n.t('usr.log_in')
    assert_select 'div > div.border-b-2.border-carmine', 'Username or password is incorrect'
  end

  test 'sessions logout logged in user can log out' do
    do_login
    get session_logout_path
    follow_redirect!

    assert_nil session[:user_id]
    assert_select "a#create_event", "Create new event"
    assert_select "a#register_btn", href: '/register', text: I18n.t('usr.register')
    assert_select "a#login_btn", href: '/login', text: I18n.t('usr.log_in')
  end
end
